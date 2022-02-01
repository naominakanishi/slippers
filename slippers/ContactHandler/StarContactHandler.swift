import SpriteKit

protocol ContactHandler {
    func handle(contact: SKPhysicsContact)
}

class StarContactHandler: ContactHandler {
    init(starManager: StarManager, player: Player) {
        self.starManager = starManager
        self.player = player
    }
    
    private let starManager: StarManager
    private let player: Player
    
    private var starCount: Int = 0
    
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
                  self.starManager.handleHit(on: node)
            else { return }
            self.player.impulse()
            self.starCount += 1
            print(self.starCount)
        }
    }
}
