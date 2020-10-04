//
//  GameScene.swift
//  Project23NinjaGame
//
//  Created by Yurii Sameliuk on 09/06/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import AVFoundation
import SpriteKit

enum ForceBomb {
    case never, always, random
}

enum SequenceType: CaseIterable {
    case oneNoBomb, one, twoWithBomb, two, three, four, chain, fastChain
}

class GameScene: SKScene {
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    var livesImages = [SKSpriteNode]()
    var lives = 3
    
    var activeSlicesBG: SKShapeNode!
    var activeSlicesFG: SKShapeNode!
    
    var activeSlicePoints = [CGPoint]()
    var isSwooshSoundActive = false
    var activeEnemies = [SKSpriteNode]()
    var bombSounEffect: AVAudioPlayer?
    //Свойство количество времени ожидания между последним врагом уничтожается и новый создается.
    var popupTime = 0.9
    //Свойство представляет собой массив из нашего SequenceTypeперечисления , который определяет , что враги , чтобы создать.
    var sequence = [SequenceType]()
    //Свойство , где мы находимся сейчас в игре.
    var sequencePosition = 0
    //Свойство , как долго ждать , прежде чем создавать новый враг , когда тип последовательности .chainили .fastChain. Цепи противника не ждут, пока предыдущий враг не окажется за кадром, прежде чем создавать нового, поэтому это все равно, что быстро бросить пять врагов, но с небольшой задержкой между каждым.
    var chainDelay = 3.0
    //Свойство используется , поэтому мы знаем , когда все враги будут уничтожены , и мы готовы создать больше.
    var nextSequenceQueued = true
    var activeExtraEnemies = [SKSpriteNode]()
    var isGameEnded = false
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .alpha
        background.zPosition = -1
        addChild(background)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -6) // -9.8 gravitacuja po umol4aniju zemli
        physicsWorld.speed = 0.85
        
        createScore()
        createLives()
        createSlices()
        // igra na4inaetsia s etoj startowoj kombinacuej dlia razminki igroka
            
            sequence = [.oneNoBomb, .oneNoBomb, .twoWithBomb, .twoWithBomb, .three, .one, .chain]
        
        for _ in 0...1000 {
            if let nextSEquence = SequenceType.allCases.randomElement() {
                sequence.append(nextSEquence)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            [weak self] in
            self?.tossEnemies()
        }
    }
    
    func createScore() {
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        gameScore.position = CGPoint(x: 8, y: 8)
        score = 0
    }
    
    func createLives() {
        for i in 0..<3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
            addChild(spriteNode)
            livesImages.append(spriteNode)
            
        }
    }
    
    func createSlices() {
        activeSlicesBG = SKShapeNode()
        activeSlicesBG.zPosition = 2
        
        activeSlicesFG = SKShapeNode()
        activeSlicesFG.zPosition = 3
        
        activeSlicesBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSlicesBG.lineWidth = 9
        
        activeSlicesFG.strokeColor = UIColor.white
        activeSlicesFG.lineWidth = 5
        
        addChild(activeSlicesBG)
        addChild(activeSlicesFG)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isGameEnded == false else {return}

        
        guard let touch = touches.first else { return  }
        
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        redrawActiveSlice()
        
        if !isSwooshSoundActive {
            playSwooshSound()
        }
        
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            if node.name == "enemy"{
                // destroy the penguin
                //Создайте эффект частиц над пингвином.
                if let emmiter = SKEmitterNode(fileNamed: "sliceHitEnemy") {
                    emmiter.position = node.position
                    addChild(emmiter)
                }
               // Очистите его имя узла, чтобы его нельзя было повторно провести
                node.name = ""
                //Отключите isDynamicего физическое тело, чтобы оно не продолжало падать.
                node.physicsBody?.isDynamic = false
                // Заставьте пингвина масштабироваться и исчезать одновременно
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])
                //После того, как пингвин масштабируется и исчезает, мы должны убрать его со сцены.
                let seq = SKAction.sequence([group, .removeFromParent()])
                node.run(seq)
                //Добавьте один к счету игрока.
                score += 1
                //Уберите врага из нашего activeEnemiesмассива.
                if let index = activeEnemies.firstIndex(of: node) {
                    activeEnemies.remove(at: index)
                }
                //Воспроизведите звук, чтобы игрок знал, что он ударил пингвина.
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            } else if node.name == "bomb" {
                // destroy the bomb
                guard let bombContainer = node.parent as? SKSpriteNode else {
                    continue
                }
                if let emmiter = SKEmitterNode(fileNamed: "sliceHitBomb") {
                    emmiter.position = bombContainer.position
                    addChild(emmiter)
                }
                node.name = ""
                bombContainer.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])
                
                let seq = SKAction.sequence([group, .removeFromParent()])
                bombContainer.run(seq)
                
                if let index = activeEnemies.firstIndex(of: bombContainer) {
                    activeEnemies.remove(at: index)
                }
                run(SKAction.playSoundFileNamed("explosion", waitForCompletion: false))
                endGame(triggeredByBomb: true)
            } else if node.name == "enemyExtra" {
               // 1
               let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy")!
               emitter.position = node.position
               addChild(emitter)

               // 2
               node.name = ""

               // 3
               node.physicsBody?.isDynamic = false

               // 4
               let scaleOut = SKAction.scale(to: 0.001, duration:0.2)
               let fadeOut = SKAction.fadeOut(withDuration: 0.2)
               let group = SKAction.group([scaleOut, fadeOut])

               // 5
               let seq = SKAction.sequence([group, SKAction.removeFromParent()])
               node.run(seq)

               // 6
               score += 50
               // 7
                guard let index = activeEnemies.firstIndex(of: node ) else {return}
               activeEnemies.remove(at: index)

               // 8
               run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }
    
    func endGame(triggeredByBomb: Bool) {
        guard isGameEnded == false else {return}
        isGameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = false
        
        bombSounEffect?.stop()
        bombSounEffect = nil
        
        if triggeredByBomb {
            livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
        }
    }
    
    func playSwooshSound() {
        isSwooshSoundActive = true
        
        let randomNumber = Int.random(in: 1...3)
        let soundName = "swoosh\(randomNumber).caf"
        
        let swooshSoung = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        
        run(swooshSoung) { [weak self] in
            self?.isSwooshSoundActive = false
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSlicesBG.run(SKAction.fadeOut(withDuration: 0.2))// 4tobu linii ne srazy propadali
        activeSlicesFG.run(SKAction.fadeOut(withDuration: 0.2))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return  }
        activeSlicePoints.removeAll(keepingCapacity: true)
        
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        redrawActiveSlice()
        
        activeSlicesBG.removeAllActions()
        activeSlicesFG.removeAllActions()
        
        activeSlicesBG.alpha = 1
        activeSlicesFG.alpha = 1
    }
    
    func redrawActiveSlice() {
        // esli kasanij menshe 2
        if activeSlicePoints.count < 2 {
            activeSlicesBG.path = nil
            activeSlicesFG.path = nil
            
            return
        }
        
        // linii nebilshe 12
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
            
        }
        
        // risyem linijy k perwoj to4ke
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        // rusuem k sled to4ke posle ydalenija
        for i in 1 ..< activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        activeSlicesBG.path = path.cgPath
        activeSlicesFG.path = path.cgPath
    }
    
    func createExtraEnemy() {
        
        let random = Int.random(in: 0 ... 4)
        if random == 2 {
        let randomAngularVelocity = CGFloat.random(in: -4...8)

        let enemyExtra = SKSpriteNode(imageNamed: "ball")
        run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
        enemyExtra.name = "enemyExtra"
        
        let randomPosition = CGPoint(x: Int.random(in: 30...800), y: -128)
        enemyExtra.position = randomPosition
        
        var randomXVelocity = 0
        
        if randomPosition.x < 240 {
            randomXVelocity = Int.random(in: 8...15)
        } else if randomPosition.x < 480 {
            randomXVelocity = Int.random(in: 3...5)
        } else if randomPosition.x < 700 {
            randomXVelocity = -Int.random(in: 3...5)
        } else {
            randomXVelocity = -Int.random(in: 8...15)
        }

        let randomYVelocity = Int.random(in: 20...39)
        enemyExtra.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemyExtra.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
        enemyExtra.physicsBody?.angularVelocity = randomAngularVelocity
        enemyExtra.physicsBody?.collisionBitMask = 0
        addChild(enemyExtra)
            activeExtraEnemies.append(enemyExtra)
        } else {
            return
        }
        
    }
    
    func createEnemy(forceBomb: ForceBomb = .random) {
        let enemy: SKSpriteNode
        let enemyTypeRandom = Int.random(in: 0 ... 6)
        var enemyType = enemyTypeRandom
        
        if forceBomb == .never {
            enemyType = 1
        } else if forceBomb == .always {
            enemyType = 0
        }
        if enemyType == 0 {
            // bomb code goes here
            // Создайте новый, SKSpriteNodeкоторый будет держать взрыватель и изображение бомбы как детей, устанавливая его положение Z равным 1.
            createExtraEnemy()
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = "bombContainer"
            
            //Создайте изображение бомбы, назовите его «бомба» и добавьте его в контейнер.
            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "bomb"
            enemy.addChild(bombImage)
            //Если воспроизводится звуковой эффект взрывателя бомбы, остановите его и уничтожьте.
            if bombSounEffect != nil {
                bombSounEffect?.stop()
                bombSounEffect = nil
            }
            //Создайте новый звуковой эффект взрывателя бомбы, затем воспроизведите его.
            if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf") {
                if let sound = try? AVAudioPlayer(contentsOf: path) {
                    bombSounEffect = sound
                    sound.play()
                }
            }
            
            //Создайте узел эмиттера частиц, расположите его так, чтобы он находился в конце предохранителя изображения бомбы, и добавьте его в контейнер.
            if let emmiter = SKEmitterNode(fileNamed: "sliceFuse") {
                emmiter.position = CGPoint(x: 76, y: 64)
                enemy.addChild(emmiter)
                
            }
        } else {
            enemy = SKSpriteNode(imageNamed: "penguin")
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
            enemy.name = "enemy"
            
        }
        // position code goes here
        //Дайте противнику случайную позицию за нижним краем экрана.
        let randomPosition = CGPoint(x: Int.random(in: 64...960), y: -128)
        enemy.position = randomPosition
        //Создайте случайную угловую скорость, то есть, как быстро что-то должно вращаться.
        let randomAngularVelocity = CGFloat.random(in: -3...3)
        let randomXVelocity: Int
        //Создайте случайную скорость X (насколько далеко двигаться по горизонтали), которая учитывает позицию противника.
        if randomPosition.x < 256 {
            randomXVelocity = Int.random(in: 8...15)
        }else if randomPosition.x < 512 {
            randomXVelocity = Int.random(in: 3...5)
        }else if randomPosition.x < 768 {
            randomXVelocity = -Int.random(in: 3...5)
        } else {
            randomXVelocity = -Int.random(in: 8...15)
        }
        //Создайте случайную скорость Y просто, чтобы заставить вещи летать на разных скоростях.
        let randomYVelocity = Int.random(in: 24...32)
        //Дайте всем врагам круговое физическое тело, в котором collisionBitMaskзначение 0, чтобы они не сталкивались.
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.collisionBitMask = 0
        
        addChild(enemy)
        activeEnemies.append(enemy)
    }
    
    func subtractLife() {
        lives -= 1
        
        run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))
        
        var life: SKSpriteNode
        
        if lives == 2 {
            life = livesImages[0]
        } else if lives == 1 {
            life = livesImages[1]
        } else {
            life = livesImages[2]
            endGame(triggeredByBomb: false)
        }
        
        life.texture = SKTexture(imageNamed: "sliceLifeGone")
        life.xScale = 1.3
        life.yScale = 1.3
        life.run(SKAction.scale(to: 1, duration: 0.1))
    }
    
    //метод вызывается каждый кадр до его отрисовки и дает вам возможность обновить состояние игры по своему усмотрению
    override func update(_ currentTime: TimeInterval) {
        if activeEnemies.count > 0 {
            for (index, node) in activeEnemies.enumerated().reversed() {
                if node.position.y < -140 {
                    node.removeAllActions()
                    
                    if node.name == "enemy" {
                        node.name = ""
                        subtractLife()
                        
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    } else if node.name == "bombContainer" {
                        node.name = ""
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    } else if node.name == "enemyExtra" {
                        node.name = ""
                        node.removeFromParent()
                        
                        if let index = activeEnemies.firstIndex(of: node) {
                        activeEnemies.remove(at: index)
                        }
                    }
                }
            }
        
        } else {
            if !nextSequenceQueued {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + popupTime) {
                    [weak self] in
                    self?.tossEnemies()
                    
                }
                
                nextSequenceQueued = true
            }
        }
        
        var bombCount = 0
        
        for node in activeEnemies {
            if node.name == "bombContainer" {
                bombCount += 1
                break
            }
        }
        
        if bombCount == 0 {
            // no bombs - stop the fuse sound
            bombSounEffect?.stop()
            bombSounEffect = nil
        }
    }

    func tossEnemies() {
        guard isGameEnded == false else {return}

        popupTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02
        
        let sequenceType = sequence[sequencePosition]
        
        switch sequenceType {
        case .oneNoBomb:
            createEnemy(forceBomb: .never)
        case .one:
            createEnemy()
        case .twoWithBomb:
            createEnemy(forceBomb: ForceBomb.never)
            createEnemy(forceBomb: ForceBomb.always)
        case .two:
            createEnemy()
            createEnemy()
        case .three:
            createEnemy()
            createEnemy()
            createEnemy()
        case .four:
            createEnemy()
            createEnemy()
            createEnemy()
            createEnemy()
        case .chain:
            createEnemy()

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (chainDelay / 5.0)) {
                [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (chainDelay / 5.0 *  2)) {
                [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (chainDelay / 5.0 * 3)) {
                [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (chainDelay / 5.0 * 4)) {
                [weak self] in
                self?.createEnemy()
            }
        case .fastChain:
            createEnemy()

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (chainDelay / 10.0)) {
                [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (chainDelay / 10.0 *  2)) {
                [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (chainDelay / 10.0 * 3)) {
                [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (chainDelay / 10.0 * 4)) {
                [weak self] in
                self?.createEnemy()
                        
        }
            sequencePosition += 1
            nextSequenceQueued = false
        }
    }
}
