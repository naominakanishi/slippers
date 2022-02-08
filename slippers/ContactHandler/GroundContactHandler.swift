import SpriteKit

final class GroundContactHandler: ContactHandler {
    private let scoreKeeper: ScoreKeeper
    private let handleContact: () -> Void
    init(scoreKeeper: ScoreKeeper, handleContact: @escaping () -> Void) {
        self.scoreKeeper = scoreKeeper
        self.handleContact = handleContact
    }
    
    func handle(contact: SKPhysicsContact) {
        handle(contact.bodyA, groundBody: contact.bodyB)
        handle(contact.bodyB, groundBody: contact.bodyA)
    }
    
    private func handle(_ playerBody: SKPhysicsBody, groundBody: SKPhysicsBody) {
        guard playerBody.categoryBitMask == CollisionMasks.player,
              groundBody.categoryBitMask == CollisionMasks.ground,
              scoreKeeper.canRestart
        else { return }
        handleContact()
    }
}
