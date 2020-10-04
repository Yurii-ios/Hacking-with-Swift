//
//  GameScene.swift
//  Project26Ball
//
//  Created by Yurii Sameliuk on 17/06/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import SpriteKit
import CoreMotion

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    
    var motionManager: CMMotionManager?
    var isGameOver = false
    
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var levelCount = 1
    
    override func didMove(to view: SKView) {
      
        createBackground()
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        loadLevel()
        
        createPlayer()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    func createBackground() {
        let background = SKSpriteNode(imageNamed: "background")
              background.position = CGPoint(x: 512, y: 384)
              background.blendMode = .replace
              background.zPosition = -1
              addChild(background)
    }
    // zagryžaem yrowen igru s tekstowogo faila
    func loadLevel() {
 print(levelCount)
        guard let levelURL = Bundle.main.url(forResource: "level\(levelCount)", withExtension: "txt") else {
            fatalError("Could not find level1.txt in the app bundle.")
        }
       
        guard let levelString = try? String(contentsOf: levelURL) else { fatalError("Could not fload level1.txt in the app bundle.") }
        // razbiwaem elementu w poly4enoj stroke
        let lines = levelString.components(separatedBy: "\n")
        
        // reversed()- 4tobu 4itat snizy w werch(y, x osi)
        for (row, line) in lines.reversed().enumerated() {
            print("It is row: \(row)")
            print("It is line: \(line)")
            for (column, letter) in line.enumerated() {
                print("It is column: \(column)")
                print("It is letter: \(letter)")
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                createWall(letter: letter, position: position)
                
                createVortex(letter: letter, position: position)
                
                createStar(letter: letter, position: position)
                
                createFinish(letter: letter, position: position)
                
                if letter == " "{
                    // this is an empty spase - do nothing
                } else if letter != "x", letter != "v", letter != "s", letter != "f", letter != "t"{
                    fatalError("Unknown level letter: \(letter)")
                }
            
        }
    }
}

func createWall(letter: Character, position: CGPoint) {
    if letter == "x" {
        // load wall
        let node = SKSpriteNode(imageNamed: "block")
        node.name = "wall"
        node.position = position
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
}

func createVortex(letter: Character, position: CGPoint) {
    if letter == "v" {
        // load vortex
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.isDynamic = false
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        addChild(node)
    }
    }
    
    func createStar(letter: Character, position: CGPoint) {
        if letter == "s" {
            // load star
            let node = SKSpriteNode(imageNamed: "star")
            node.name = "star"
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.isDynamic = false
            
            node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask = 0
            node.position = position
            addChild(node)
        }
    }
    
    func createFinish(letter: Character, position: CGPoint) {
        if letter == "f" {
            // load finish point
            let node = SKSpriteNode(imageNamed: "finish")
            node.name = "finish"
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.isDynamic = false
            
            node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask = 0
            node.position = position
            addChild(node)
    
        }
        }

    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return  }
        
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return  }
        
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else {return}
        
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition {
            let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: ccelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) {
                [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            node.removeFromParent()
            node.removeAllChildren()
            removeAllChildren()
            levelCount += 1
            createBackground()
            createPlayer()
            loadLevel()
            
             
        }
    }
}
