//
//  GameScene.swift
//  Project29ExplodingMonkeys
//
//  Created by Yurii Sameliuk on 26/06/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import SpriteKit

enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var buildings = [BuldingNode]()
    weak var viewController: GameViewController?
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    
    var windSpeed: CGFloat = 0
    let earthsGravity: CGFloat = -9.8
    
    var currentPlayer = 1
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        createBuildings()
        createPlayers()
        setWind()
        
        physicsWorld.contactDelegate = self
    }
    
    func createBuildings() {
        var currentX: CGFloat = -15
        
        while currentX < 1024 {
            let size = CGSize(width: Int.random(in: 2 ... 4) * 40, height: Int.random(in: 300 ... 600))
            
            currentX += size.width + 2
            
            let building = BuldingNode(color: .red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }
    
    func createPlayers() {
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.isDynamic = false
        
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
        addChild(player1)
        
        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        player2.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player2.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.isDynamic = false
        
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + ((player2Building.size.height + player2.size.height) / 2))
        addChild(player2)
    }
    
    func setWind() {
           
           // Challenge 3: Use the physics world’s gravity to add random wind to each level, making sure to add a label telling players the direction and strength.
           windSpeed = CGFloat.random(in: -2...2)
           physicsWorld.gravity = CGVector(dx: windSpeed, dy: earthsGravity)

           let displayedSpeed = Int(abs(windSpeed) * 15)
           
           switch windSpeed {
           case _ where windSpeed < 0:
               viewController?.windLabel.text = "<<< Wind \(displayedSpeed)"
           case _ where windSpeed > 0:
               viewController?.windLabel.text = "Wind \(displayedSpeed) >>>"
           default:
               viewController?.windLabel.text = "Wind calm"
           }
       }
    
    func launch(angle: Int, velocity: Int) {
        // 1 Выясните, как трудно бросить банан. Мы принимаем параметр скорости, но я разделю его на 10. Вы можете настроить его, основываясь на собственном игровом тестировании.
           let speed = Double(velocity) / 10.0

           // 2 Преобразовать входной угол в радианы. Большинство людей не думают в радианах, поэтому входные данные будут представлены в градусах, которые мы будем переводить в радианы.
           let radians = deg2rad(degrees: angle)

           // 3 Если какой-то банан уже есть, мы удалим его и создадим новый, используя физику окружностей.
           if banana != nil {
               banana.removeFromParent()
               banana = nil
           }

           banana = SKSpriteNode(imageNamed: "banana")
           banana.name = "banana"
           banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
           banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
           banana.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
           banana.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
           banana.physicsBody?.usesPreciseCollisionDetection = true
           addChild(banana)

           if currentPlayer == 1 {
               // 4 Если игрок 1 бросал банан, мы помещаем его вверх и влево от игрока и немного вращаем.
               banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
               banana.physicsBody?.angularVelocity = -20

               // 5 Анимационный игрок 1 поднимает руку и снова опускает.
               let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
               let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
               let pause = SKAction.wait(forDuration: 0.15)
               let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
               player1.run(sequence)

               // 6 Заставьте банан двигаться в правильном направлении.
               let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
               banana.physicsBody?.applyImpulse(impulse)
           } else {
               // 7 Если игрок 2 бросал банан, мы помещаем его вверх и вправо, применяем противоположное вращение, затем заставляем его двигаться в правильном направлении.
               banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
               banana.physicsBody?.angularVelocity = 20

               let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
               let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
               let pause = SKAction.wait(forDuration: 0.15)
               let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
               player2.run(sequence)

               let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
               banana.physicsBody?.applyImpulse(impulse)
           }
    }
    
    func deg2rad(degrees: Int) -> Double {
        // pereobrazowanie w radianu
        return Double(degrees) * Double.pi / 180
    }
 //MARK: - Delegate Method
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        guard let firstNode = firstBody.node else { return }
        guard let secondNode = secondBody.node else { return }

        if firstNode.name == "banana" && secondNode.name == "building" {
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
        }

        if firstNode.name == "banana" && secondNode.name == "player1" {
            destroy(player: player1)
        }

        if firstNode.name == "banana" && secondNode.name == "player2" {
            destroy(player: player2)
        }
    }
    
    func destroy(player: SKSpriteNode) {
        
        var resetScores = false
        
        if currentPlayer == 1 {
            viewController?.player1Score += 1
        } else {
            viewController?.player2Score += 1
        }
        
        if viewController?.player1Score == 3 || viewController?.player2Score == 3 {
            viewController?.playerNumber.text = "Game Over! Player \(currentPlayer) wins!"
            resetScores = true
        }
        
        if let explosion = SKEmitterNode(fileNamed: "hitPlayer") {
            explosion.position = player.position
            addChild(explosion)
        }

        player.removeFromParent()
        banana.removeFromParent()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let newGame = GameScene(size: self.size)
            newGame.viewController = self.viewController
            self.viewController?.currentGame = newGame

            self.changePlayer()
            newGame.currentPlayer = self.currentPlayer

            let transition = SKTransition.doorway(withDuration: 1.5)
            self.view?.presentScene(newGame, transition: transition)
        }
    }
    
    func restartGame(resetScores: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            
            guard let self = self else { return }
            
            if resetScores {
                self.viewController?.player1Score = 0
                self.viewController?.player2Score = 0
            }
            
            let newGame = GameScene(size: self.size)
            newGame.viewController = self.viewController
            self.viewController?.currentGame = newGame
            
            self.changePlayer()
            newGame.currentPlayer = self.currentPlayer
            
            let transition = SKTransition.doorway(withDuration: 1.5)
            self.view?.presentScene(newGame, transition: transition)
        }
    }
    
    func changePlayer() {
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }

        viewController?.activatePlayer(number: currentPlayer)
    }
    
    func bananaHit(building: SKNode, atPoint contactPoint: CGPoint) {
        guard let building = building as? BuldingNode else { return }
        let buildingLocation = convert(contactPoint, to: building)
        building.hit(at: buildingLocation)

        if let explosion = SKEmitterNode(fileNamed: "hitBuilding") {
            explosion.position = contactPoint
            addChild(explosion)
        }

        banana.name = ""
        banana.removeFromParent()
        banana = nil

        changePlayer()
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else { return }

        if abs(banana.position.y) > 1000 {
            banana.removeFromParent()
            banana = nil
            changePlayer()
        }
    }
}
