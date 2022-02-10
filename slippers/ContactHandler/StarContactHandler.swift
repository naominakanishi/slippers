import SpriteKit

protocol ContactHandler {
    func handle(contact: SKPhysicsContact)
}

class StarContactHandler: ContactHandler {
    
    private let starManager: StarManager
    private let player: Player
    private let pointSpawner: PointSpawner
    private let scoreTracker: Scorer
    private let soundConfig: SoundConfig
    private let removeInstructions: () -> Void
    
    var hitSound: SKAudioNode?
    
    init(starManager: StarManager,
         player: Player,
         pointSpawner: PointSpawner,
         scoreTracker: Scorer,
         soundConfig: SoundConfig,
         removeInstructions: @escaping () -> Void) {
        self.starManager = starManager
        self.player = player
        self.pointSpawner = pointSpawner
        self.scoreTracker = scoreTracker
        self.soundConfig = soundConfig
        self.removeInstructions = removeInstructions
    }
    
    func handle(contact: SKPhysicsContact) {
        processContact(playerBody: contact.bodyA, starBody: contact.bodyB)
        processContact(playerBody: contact.bodyB, starBody: contact.bodyA)
    }
    
    func playHitsound(node: SKNode) {
        guard soundConfig.isSoundOn else { return }
        if let musicURL = Bundle.main.url(forResource: "hitsound", withExtension: "mp3") {
            //hitSound?.removeFromParent()
            hitSound = SKAudioNode(url: musicURL)
            hitSound?.autoplayLooped = false
            
            node.addChild(hitSound!)
            node.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.1),
                SKAction.run({
                    self.hitSound?.run(.play())
                })
            ]))
        }
    }
    
    private func processContact(playerBody: SKPhysicsBody, starBody: SKPhysicsBody) {
        guard playerBody.categoryBitMask == CollisionMasks.player &&
                starBody.categoryBitMask == CollisionMasks.star
        else { return }
        DispatchQueue.main.async {
            guard let node = starBody.node as? SKSpriteNode,
                  let previousPosition = starBody.node?.position,
                  self.starManager.handleHit(on: node)
            else { return }
            self.player.impulse()
            self.scoreTracker.handleScore()
            self.pointSpawner.spawn(at: previousPosition)
            self.playHitsound(node: node)
            self.removeInstructions()
        }
    }
}
