//
//  TestViewController.swift
//  Magic Fight
//
//  Created by Fomagran on 2021/05/13.
//

import UIKit
import SceneKit
import SpriteKit


class TestViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        guard let confettiImageView = UIImageView.fromGif(frame: CGRect(x: 0, y: 0, width: 200, height: 200), resourceName: "무_샘플") else { return }
         view.addSubview(confettiImageView)
         confettiImageView.startAnimating()
       
    }


}

extension UIImageView {
    static func fromGif(frame: CGRect, resourceName: String) -> UIImageView? {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else {
            print("Gif does not exist at that path")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        let gifImageView = UIImageView(frame: frame)
        gifImageView.animationImages = images
        return gifImageView
    }
}

extension SKView {
 convenience init(withEmitter name: String) {
  self.init()

  self.frame = UIScreen.main.bounds
  backgroundColor = .clear

  let scene = SKScene(size: self.frame.size)
  scene.backgroundColor = .clear

  guard let emitter = SKEmitterNode(fileNamed: name + ".sks") else { return }
  emitter.name = name
  emitter.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)

  scene.addChild(emitter)
  presentScene(scene)
 }
}
