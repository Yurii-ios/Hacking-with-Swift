//
//  GameScene.swift
//  ConsolidationsVII
//
//  Created by Yurii Sameliuk on 29/05/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var backgroundImage: SKSpriteNode!
   
    override func didMove(to view: SKView) {
        backgroundImage = SKSpriteNode(imageNamed: "background")
        backgroundImage.position = CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>)
        backgroundImage.zPosition = -1
        addChild(backgroundImage)
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
       
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    
    }
    
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
    }
}
