import SpriteKit

protocol ContactHandler {
    func handle(contact: SKPhysicsContact)
}

class StarContactHandler: ContactHandler {
    
    private let starManager: StarManager
    private let player: Player
    private let pointSpawner: PointSpawner
    private let scoreTracker: Scorer
    
    var hitSound: SKAudioNode?

    
    init(starManager: StarManager, player: Player, pointSpawner: PointSpawner, scoreTracker: Scorer) {
        self.starManager = starManager
        self.player = player
        self.pointSpawner = pointSpawner
        self.scoreTracker = scoreTracker
    }
    
    func handle(contact: SKPhysicsContact) {
        processContact(playerBody: contact.bodyA, starBody: contact.bodyB)
        processContact(playerBody: contact.bodyB, starBody: contact.bodyA)
    }
    
    func playHitsound(node: SKNode) {
        if let musicURL = Bundle.main.url(forResource: "hitsound", withExtension: "mp3") {
            //hitSound?.removeFromParent()
            hitSound = SKAudioNode(url: musicURL)
            hitSound?.autoplayLooped = false
            
            node.addChild(hitSound!)
            node.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.1),
                SKAction.run({
                    self.hitSound?.run(SKAction.play())
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
            
            
        }
    }
}
