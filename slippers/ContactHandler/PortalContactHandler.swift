import SpriteKit

class PortalContactHandler: ContactHandler {
    
    private let player: Player
    private let scene: Colorize
    private let portalManager: PortalManager
    
    init(player: Player, scene: Colorize, portalManager: PortalManager) {
        self.player = player
        self.scene = scene
        self.portalManager = portalManager
    }
    
    func handle(contact: SKPhysicsContact) {
        processContact(portalBody: contact.bodyA, playerBody: contact.bodyB)
        processContact(portalBody: contact.bodyB, playerBody: contact.bodyA)
    }
    
    private func processContact(portalBody: SKPhysicsBody, playerBody: SKPhysicsBody) {
        guard playerBody.categoryBitMask == CollisionMasks.player &&
                portalBody.categoryBitMask == CollisionMasks.portal
        else { return }
        print("cu da pantufa")
        DispatchQueue.main.async {
            guard let node = portalBody.node as? SKSpriteNode,
                  self.portalManager.handleHit(on: node)
            else { return }
            self.player.impulse()
            self.scene.apply(color: self.portalManager.currentColor)
            self.portalManager.nextColor()
        }
    }
}
