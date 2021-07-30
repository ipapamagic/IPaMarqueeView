//
//  IPaMarqueeViewCell.swift
//  Pods
//
//  Created by IPa Chen on 2020/1/26.
//

import UIKit
import IPaUIKitHelper
protocol IPaMarqueeViewCellDelegate {
    func onTap(_ cell:IPaMarqueeViewCell)
}
class IPaMarqueeViewCell: UIView {
    var delegate:IPaMarqueeViewCellDelegate!
    
    @IBOutlet var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var textLabel: IPaUILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate.onTap(self)
        
    }
}
