//
//  IPaMarqueeView.swift
//  IPaMarqueeView
//
//  Created by IPa Chen on 2020/1/22.
//

import UIKit
import IPaDesignableUI
@objc public protocol IPaMarqueeViewDelegate {
    @objc optional func onTap(_ marqueeView:IPaMarqueeView,for itemIndex:Int)
}
public class IPaMarqueeView: UIView {
    var displayLink:CADisplayLink?
    var startX:CGFloat = 0
    var targetX:CGFloat = 0
    var startTime:TimeInterval = 0
    
    var _currentDisplayIndex:Int = 0
    var currentDisplayIndex:Int {
        get {
            return _currentDisplayIndex
        }
        set {
            self._currentDisplayIndex = newValue % self.texts.count
            self.loadCurrentCell()
        }
    }
    @IBOutlet var displayCell:[IPaMarqueeViewCell]!
    public var texts = [String]() {
        didSet {
            self.loadCurrentCell()
        }
    }
    static var bundle:Bundle {
        get {
            let bundle = Bundle(for: IPaMarqueeView.self)
            let bundleUrl = bundle.url(forResource: "IPaMarqueeView", withExtension: "bundle")!
            return Bundle(url: bundleUrl)!
        }
    }
    @IBOutlet var contentScrollView: UIScrollView!
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //duration for one page
    open var speed:CGFloat = 50
    var _isRunning = false
    open var isRunning:Bool {
        get {
            return _isRunning
        }
    }
    open var delegate:IPaMarqueeViewDelegate?
    open var contentInset:UIEdgeInsets {
        get {
            return self.contentScrollView.contentInset
        }
        set {
            self.contentScrollView.contentInset = newValue
        }
    }
    
    
    func initialSetting() {
        IPaMarqueeView.bundle.loadNibNamed("IPaMarqueeContentView", owner: self, options: nil)
        self.contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.contentScrollView)
        self.contentScrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.contentScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.contentScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.contentScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        for cell in self.displayCell {
            
            self.configureCell(cell)
        }
        self.displayCell.sort { (firstCell, secondCell) -> Bool in
            return firstCell.frame.minX < secondCell.frame.minX
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetting()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetting()
    }
    func configureCell(_ cell:IPaMarqueeViewCell) {
        cell.delegate = self
    }
    func realIndex(for index:Int ) -> Int {
        return index % self.texts.count
    }
    @objc func onTick(_ displayLink:CADisplayLink)
    {
        if !self.isRunning {
            displayLink.invalidate()
            self.displayLink = nil
            return
        }
        let thisTick = CACurrentMediaTime()
        
        let distance = CGFloat(thisTick - self.startTime) * self.speed
        var offset = self.contentScrollView.contentOffset
        offset.x = self.startX + distance
        
        self.contentScrollView.setContentOffset(offset, animated: false)
        let cellLength = self.displayCell.first!.widthConstraint.constant
        
        
        if distance >= cellLength {
            self.currentDisplayIndex += 1
            self.contentScrollView.contentOffset = .zero
            self.doRunMarquee()
        }
        
    }
    func loadCurrentCell() {
        var index = self.currentDisplayIndex
        let pageSize = self.contentScrollView.frame.width
        for subView in self.displayCell {
            let text = self.texts[index]
            let cell = subView
            cell.textLabel.text = text
            cell.widthConstraint.isActive = false
            cell.textLabel.sizeToFit()
            let ratio = Int(cell.textLabel.frame.width / pageSize) + 1
            var frame = cell.textLabel.frame
            frame.size.width = pageSize * CGFloat(ratio)
            cell.widthConstraint.constant = frame.size.width
            frame.size.height = self.contentScrollView.frame.height
            cell.textLabel.frame = frame
            cell.widthConstraint.isActive = true
            cell.textLabel.layoutIfNeeded()
            
            
            index += 1
            index %= self.texts.count
        }
        
        
    }
    
    
    public func runMarquee() {
        if self.isRunning {
            return
        }
        self._isRunning = true
        self.doRunMarquee()
        let displayLink = CADisplayLink(target: self, selector: #selector(onTick(_:)))
        displayLink.preferredFramesPerSecond = 60
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
        self.displayLink = displayLink
        
    }
    func doRunMarquee() {
        let offset = self.contentScrollView.contentOffset
//        let cellLength = self.displayCell.first!.widthConstraint.constant
//        let pageWidth = self.contentScrollView.frame.size.width
//
        self.startX = offset.x
        self.targetX = offset.x + self.displayCell.first!.widthConstraint.constant
        self.startTime = CACurrentMediaTime()
        
        
//
//        UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear,.allowUserInteraction] , animations: {
//            offset.x += self.displayCell.first!.widthConstraint.constant
//            self.contentScrollView.contentOffset = offset
//
//        }, completion: {
//            finished in
//            if !finished {
//                return
//            }
//            self.contentScrollView.setContentOffset(.zero, animated: false)
//            self.currentDisplayIndex += 1
//
//
//            self.doRunMarquee()
//        })
    }
}

extension IPaMarqueeView: UIScrollViewDelegate {
    
}
extension IPaMarqueeView: IPaMarqueeViewCellDelegate
{
    func onTap(_ cell: IPaMarqueeViewCell) {
        let index = self.displayCell.firstIndex(of: cell) ?? 0
        self.delegate?.onTap?(self, for: index)
        
    }
}
