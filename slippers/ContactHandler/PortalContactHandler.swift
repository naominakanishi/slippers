import SpriteKit

class PortalContactHandler: ContactHandler {
    
    private let player: Player
    private let scene: Colorize
    private let portalManager: PortalManager
    private let doubleScoreSpawner: DoubleScoreZoneSpawner
    
    private let scoreTracker: ScoreTracker
    
    init(player: Player,
         scene: Colorize,
         portalManager: PortalManager,
         doubleScoreSpawner: DoubleScoreZoneSpawner,
         scoreTracker: ScoreTracker) {
        self.player = player
        self.scene = scene
        self.portalManager = portalManager
        self.doubleScoreSpawner = doubleScoreSpawner
        self.scoreTracker = scoreTracker
    }
    
    func handle(contact: SKPhysicsContact) {
        processContact(portalBody: contact.bodyA, playerBody: contact.bodyB)
        processContact(portalBody: contact.bodyB, playerBody: contact.bodyA)
    }
    
    private func processContact(portalBody: SKPhysicsBody, playerBody: SKPhysicsBody) {
        guard playerBody.categoryBitMask == CollisionMasks.player &&
                portalBody.categoryBitMask == CollisionMasks.portal
        else { return }
        DispatchQueue.main.async {
            guard let node = portalBody.node as? SKSpriteNode,
                  self.portalManager.handleHit(on: node)
            else { return }
            self.player.impulse()
            self.scoreTracker.multiply()
            self.doubleScoreSpawner.spawn()
            self.scene.apply(color: self.portalManager.currentColor)
            self.portalManager.nextColor()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.reversePortal()
            }
        }
       
    }
    
    private func reversePortal() {
        self.scene.apply(color: UIColor.white)
        self.scoreTracker.endMultiplication()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.portalManager.nextColor()

        }
        
        //todo desfazer toda a lógica do portal
    }
}
