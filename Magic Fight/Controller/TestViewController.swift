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

    
    var skView:SKView = {
        let view = SKView(withEmitter: "MagicParticle")
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(skView)
        
        skView.translatesAutoresizingMaskIntoConstraints = false
        skView.centerXAnchor.constraint(equalTo:view.centerXAnchor)
                  .isActive = true
        skView.centerYAnchor.constraint(equalTo:view.centerYAnchor)
                  .isActive = true
        skView.heightAnchor.constraint(equalToConstant: 200)
                  .isActive = true
        skView.widthAnchor.constraint(equalToConstant: 200)
                  .isActive = true
        
       
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
