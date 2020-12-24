//
//  ViewController.swift
//  LayerKit-POC
//
//  Created by Zach Eriksen on 12/22/20.
//

import UIKit
import LayerKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bounds = view.bounds
        
        let width: CGFloat = bounds.width - 32
        let height: CGFloat = bounds.height - 32
        
        view.layer
            .background(color: UIColor.cyan.cgColor)
            .embed {
                CAScrollLayer(backgroundColor: UIColor.brown.cgColor)
                    .corner(radius: 32)
                    .masked(corners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner])
                    .frame(x: 16, y: 16, width: width, height: height)
                    .configure { scrollLayer in
                        scrollLayer.drawsAsynchronously = true
                        let padding: CGFloat = 8
                        
                        let scrollItemHeight: CGFloat = 320
                        let subScrollItemHeight: CGFloat = 32
                        
                        
                        let numberOfScrollItems: Int = 100
                        let numberOfSubScrollItems: Int = 1000
                        
                        
                        for index in (0 ..< numberOfScrollItems) {
                            scrollLayer.embed {
                                Layer(backgroundColor: UIColor.orange.cgColor)
                                    .frame(x: 16, y: CGFloat(index) * (scrollItemHeight + padding), width: width - 32, height: scrollItemHeight)
                                    .corner(radius: 16)
                                    .embed {
                                        CAScrollLayer(backgroundColor: UIColor.purple.cgColor)
                                            .frame(x: 16, y: 16, width: width - 64, height: scrollItemHeight - 32)
                                            .corner(radius: 8)
                                            .configure { scrollLayer in
                                                scrollLayer.drawsAsynchronously = true
                                                let padding: CGFloat = 8
                                                for index in (0 ..< numberOfSubScrollItems) {
                                                    scrollLayer.embed {
                                                        Layer(backgroundColor: UIColor.magenta.cgColor)
                                                            .frame(x: 16, y: CGFloat(index) * (subScrollItemHeight + padding), width: width - 96, height: subScrollItemHeight)
                                                            .corner(radius: 16)
                                                            .configure { $0.drawsAsynchronously = true }
                                                    }
                                                }
                                                
                                                keepRandomlyDoing {
                                                    scrollLayer.scroll(
                                                        .init(x: 0, y: (numberOfSubScrollItems - Int.random(in: 1 ... numberOfSubScrollItems)) * Int(subScrollItemHeight + padding))
                                                    )
                                                }
                                            }
                                        
                                    }
                                    .configure { $0.drawsAsynchronously = true }
                            }
                        }
                        
                        keepRandomlyDoing {
                            scrollLayer.scroll(
                                .init(x: 0, y:  (numberOfScrollItems - Int.random(in: 1 ... numberOfScrollItems)) * Int(scrollItemHeight + padding))
                            )
                        }
                    }
            }
            .configure { $0.drawsAsynchronously = true }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print(#function)
        
        let bounds = view.bounds
        
        let width: CGFloat = bounds.width - 32
        let height: CGFloat = bounds.height - 32
        
        let x: CGFloat = 16
        let y: CGFloat = 16
        
        
        view.layer.sublayers?.first?.frame(x: x, y: y, width: width, height: height)
    }
    
    func randomlyDo(something: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int.random(in: 0 ... 5))) {
            something()
        }
    }
    
    func keepRandomlyDoing(something: @escaping () -> Void) {
        randomlyDo {
            something()
            self.keepRandomlyDoing(something: something)
        }
    }
}
