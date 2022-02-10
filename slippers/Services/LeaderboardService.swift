import GameKit

protocol LeaderboardScoreSender {
    func send(score: Int)
}

final class LeaderboardService {
    private let currentPlayer = GKLocalPlayer.local
    private let leaderboardId = "cc.nimidesign.nijijump.permanent"
    
    private let presentAuthenticationViewController: (UIViewController) -> Void
    private let presentLeaderboardViewController: (GKGameCenterViewController) -> Void
    
    init(
        presentAuthenticationViewController: @escaping (UIViewController) -> Void,
        presentLeaderboardViewController: @escaping (GKGameCenterViewController) -> Void
    ) {
        self.presentAuthenticationViewController = presentAuthenticationViewController
        self.presentLeaderboardViewController = presentLeaderboardViewController
    }
    
    func initialize() {
        currentPlayer.authenticateHandler = handleAuthentication
    }
    
    func showLeaderboard() {
        guard currentPlayer.isAuthenticated else { return }
        let controller = GKGameCenterViewController(leaderboardID: leaderboardId,
                                   playerScope: .global,
                                   timeScope: .allTime)
        presentLeaderboardViewController(controller)
    }
    
    private func handleAuthentication(_ viewController: UIViewController?, _ error: Error?) {
        if let error = error {
            // TODO handle error
            return
        }
        
        if let viewController = viewController {
            presentAuthenticationViewController(viewController)
            return
        }
    }
}

extension LeaderboardService: LeaderboardScoreSender {
    func send(score: Int) {
        GKLeaderboard.submitScore(score, context: 0, player: currentPlayer, leaderboardIDs: [leaderboardId]) {
            if let error = $0 {
                print("Failed to submit score!", error)
            }
        }
    }
}
