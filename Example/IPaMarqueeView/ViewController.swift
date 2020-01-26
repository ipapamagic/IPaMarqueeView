//
//  ViewController.swift
//  IPaMarqueeView
//
//  Created by ipapamagic@gmail.com on 01/22/2020.
//  Copyright (c) 2020 ipapamagic@gmail.com. All rights reserved.
//

import UIKit
import IPaMarqueeView
import IPaDesignableUI
class ViewController: UIViewController {
    let texts = ["IPaMarqueeView is awesown!!!!!!!!IPaMarqueeView is awesown!!!!!!!!IPaMarqueeView is awesown!!!!!!!!","test 123456789","I am so tired,I need to get rest!!"]
    @IBOutlet weak var marqueeView: IPaMarqueeView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        marqueeView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        marqueeView.texts = texts
        
        marqueeView.runMarquee()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension ViewController:IPaMarqueeViewDelegate
{
    func onTap(_ marqueeView: IPaMarqueeView, for itemIndex: Int) {
        print("tap:\(itemIndex)")
    }
    
}