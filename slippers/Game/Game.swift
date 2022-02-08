import SpriteKit

final class Game {
    private let scoreTracker: ScoreTrackerProtocol
    private let scene: GameScene
    private let camera = SKCameraNode()
    
    private lazy var player = Player(imageName: "player-standing")
    private lazy var ground = Ground(imageName: "ground")
    private lazy var point = PointSpawner(
        scene: scene,
        scoreTracker: scoreTracker)
    private lazy var doubleScoreMessage = DoubleScoreZoneSpawner(scene: scene)
    private lazy var scoreEntity = Score(currentPoints: scoreTracker,
                                         node: .init())
    
//    private lazy var instructionMessage: UILabel = {
//        let view = UILabel()
//        view.font = .amatic(.bold, 24)
//        view.textColor = .white
//        view.textAlignment = .center
//        view.text = "JUMP THROUGH AS MANY STARS AS YOU CAN"
//        return view
//    }()
//
//    private var currentMessageIndex = 0
//
//    private var messages: [String] = [
//        "JUMP THROUGH AS MANY STARS AS YOU CAN",
//        "USE THE COLOR PORTALS TO GET A SCORE BOOST",
//        "SET NEW RECORDS GOING HIGHER EVERY TIME",
//    ]
    
    private lazy var starManager: StarManager = {
        let node = SKNode()
        return StarManager(
            scoreTracker: scoreTracker,
            scene: self.scene,
            player: player,
            node: node,
            spawnCount: 10)
    }()
    
    private lazy var portalManager: PortalManager = {
        let node = SKNode()
        return PortalManager(
            scene: scene,
            player: player,
            node: node,
            spawnCount: 10  )
    }()
    
    private lazy var background: Background = {
        let node = SKSpriteNode(imageNamed: "background")
        return Background(playerNode: player.node, node: node)
    }()
    
    private lazy var contactHandlers: [ContactHandler] = [
        StarContactHandler(
            starManager: starManager,
            player: player,
            pointSpawner: point,
            scoreTracker: scoreTracker),
        PortalContactHandler(
            player: player,
            scene: self,
            portalManager: portalManager,
            doubleScoreSpawner: doubleScoreMessage,
            scoreTracker: scoreTracker),
        GroundContactHandler(scoreKeeper: scoreTracker) {
            self.onGameOver?()
        }
    ]
    
    var onGameOver: (() -> Void)?
    
    init(scene: GameScene, scoreTracker: ScoreTrackerProtocol) {
        self.scene = scene
        self.scoreTracker = scoreTracker
    }
    
//    private func changeMessage() {
//        currentMessageIndex += 1
//        if currentMessageIndex >= messages.count { currentMessageIndex = 0 }
//        instructionMessage.text = messages[currentMessageIndex]
//
//    }
//
//    private func fadeIn() {
//        UIView.animate(withDuration: 2) {
//            self.instructionMessage.alpha = 1
//        } completion: { _ in
//            self.fadeOut()
//        }
//
//    }
//
//    private func fadeOut() {
//        UIView.animate(withDuration: 2) {
//            self.instructionMessage.alpha = 0
//        } completion: { _ in
//            self.changeMessage()
//            self.fadeIn()
//        }
//    }
    
    func setup() {
        scene.camera = camera
        scene.addChild(camera)
        camera.position = .zero
        
        scene.addEntity(background)
        scene.addEntity(player)
        scene.addEntity(ground)
        
        starManager.spawnInitialBatch()
        portalManager.spawnInitialBatch()
        
        ground.node.position.y = scene.frame.minY + ground.node.frame.height / 6
        ground.configurePlayer(player: player.node)
        
        scene.addEntity(starManager)
        starManager.node.position.y = scene.frame.height
        camera.addChild(scoreEntity.node)
        scoreEntity.node.position.x = scene.frame.minX + 20 + scoreEntity.node.frame.width / 2
        scoreEntity.node.position.y = scene.frame.maxY - 50 + scoreEntity.node.frame.height / 2
    }
    
    
    
    func update(deltaTime: TimeInterval) {
        starManager.update(deltaTime: deltaTime)
        portalManager.update(deltaTime: deltaTime)
        player.update(deltaTime: deltaTime)
        scoreEntity.update(deltaTime: deltaTime)
        checkIfGameIsOver()
    }
    
    func didSimulatePhysics() {
        player.didSimulatePhysics()
    }
    
    func touchDown(at location: CGPoint) {
        if player.physicsBody?.velocity == .zero {
            player.impulse()
        }
    }
    
    func touchMoved(to location: CGPoint) {
        player.move(to: location)
    }
    
    func touchUp(at location: CGPoint) {}
    
    func handle(contact: SKPhysicsContact) {
        contactHandlers.forEach{
            $0.handle(contact: contact)
        }
    }
    
    func syncCamera(deltaTime: TimeInterval) {
        camera.position.y = max(player.node.position.y, 0)
        background.update(deltaTime: deltaTime)
    }
    
    private func checkIfGameIsOver() {
        let yThreshold: CGFloat = -2000
        if (player.physicsBody?.velocity.dy ?? 0) < yThreshold {
            onGameOver?()
            return
        }
    }
}


extension Game: Colorize {
    func apply(color: UIColor) {
        let colorizeables: [Colorize] = [
            portalManager, starManager,
            player, background
        ]
        
        colorizeables.forEach { $0.apply(color: color) }
    }
}

extension UIColor {
    static func random() -> UIColor {
        Colors.random()
    }
}
