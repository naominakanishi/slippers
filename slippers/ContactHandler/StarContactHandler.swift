import SpriteKit

protocol ContactHandler {
    func handle(contact: SKPhysicsContact)
}

class StarContactHandler: ContactHandler {

    
    private let starManager: StarManager
    private let player: Player
    private let pointSpawner: PointSpawner
    private let scoreTracker: ScoreTracker
    
    
    init(starManager: StarManager, player: Player, pointSpawner: PointSpawner, scoreTracker: ScoreTracker) {
        self.starManager = starManager
        self.player = player
        self.pointSpawner = pointSpawner
        self.scoreTracker = scoreTracker
    }
    
    func handle(contact: SKPhysicsContact) {
        processContact(playerBody: contact.bodyA, starBody: contact.bodyB)
        processContact(playerBody: contact.bodyB, starBody: contact.bodyA)
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
            self.scoreTracker.score()
            self.pointSpawner.spawn(at: previousPosition)
        }
    }
}
