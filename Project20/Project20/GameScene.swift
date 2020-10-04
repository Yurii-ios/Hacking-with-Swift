//
//  GameScene.swift
//  Project20
//
//  Created by Yurii Sameliuk on 02/06/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    var label: SKLabelNode!
    
    var timerCount = 7.0
    
    let leftEdge = -22
    let bottomEdge = -22
    let rigthEdgr = 1024 + 22
    
    
    var score = 0 {
        didSet {
            label.text = "Score: \(score)"
        }
    }
    override func didMove(to view: SKView) {
        
        
        // label
        label = SKLabelNode(fontNamed: "Chalkduster")
        label.position = CGPoint(x: 80, y: 20)
        label.horizontalAlignmentMode = .center
        label.text = "Score: 0"
        label.zPosition = 1
        label.fontSize = 30
        addChild(label)
        
        // background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        // create timer
        gameTimer = Timer.scheduledTimer(timeInterval: timerCount, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    
    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int ) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        default:
            firework.color = .red
        }
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        let move = SKAction.follow(path.cgPath, asOffset: true,orientToPath: true, speed: 200)
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        fireworks.append(node)
        addChild(node)
    }
    
    @objc func launchFireworks( ) {
        let movementAmount: CGFloat = 1800
        
        switch Int.random(in: 0...3) {
        case 0:
            // fire five straigth up
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
        case 1:
            // fire five, in a fan
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: +100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: +200, x: 512 + 200, y: bottomEdge)
        case 2:
            // fire five, from the left to the right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
            case 3:
            // fire five, from the rigth to the left
            createFirework(xMovement: -movementAmount, x: rigthEdgr, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rigthEdgr, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rigthEdgr, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rigthEdgr, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rigthEdgr, y: bottomEdge)
        default:
            break
        }
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else {return}
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue } // propyskaem esli ne firework
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if timerCount == 30 {
                   gameTimer?.invalidate()
               }
        for (index, firework) in fireworks.enumerated() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
                
            }
        }
    }
    
    func explode(firework: SKNode) {
        if let emmiter = SKEmitterNode (fileNamed: "explode") {
            emmiter.position = firework.position
            addChild(emmiter)
            
        }
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else {continue}
            
            if firework.name == "selected" {
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                
                numExploded += 1
                timerCount -= 1
            }
        }
        switch numExploded {
        case 0:
            break
        case 1:
            score += 200
            label.fontColor = .white
        case 2:
            score += 500
            label.fontColor = .yellow
        case 3:
            score += 1500
            label.fontColor = .orange
        case 4:
            score += 2500
            label.fontColor = .red
        default:
            score += 4000
            label.fontColor = .systemIndigo
            gameTimer?.invalidate()
        }
    }
}
