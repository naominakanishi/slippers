import GameKit

protocol LeaderboardScoreSender {
    func send(score: Int)
}

protocol LeaderboardServiceDelegate: AnyObject {
    func present(authenticationViewController: UIViewController)
    func present(leaderboardViewController: GKGameCenterViewController)
    func didAuthenticate()
}

final class LeaderboardService {
    private let currentPlayer = GKLocalPlayer.local
    private let leaderboardId = "cc.nimidesign.nijijump.permanent"
    
    weak var delegate: LeaderboardServiceDelegate?
    
    func initialize() {
        currentPlayer.authenticateHandler = handleAuthentication
    }
    
    func showLeaderboard() {
        guard currentPlayer.isAuthenticated else { return }
        let controller = GKGameCenterViewController(leaderboardID: leaderboardId,
                                   playerScope: .global,
                                   timeScope: .allTime)
        delegate?.present(leaderboardViewController: controller)
    }
    
    func loadBoardHighscore(completion: @escaping (Int) -> Void) {
        GKLeaderboard.loadLeaderboards(IDs: [leaderboardId]) { leaderboard, error in
            leaderboard?.first?.loadEntries(for: [self.currentPlayer],
                                               timeScope: .allTime
            ) { entry, entries, _ in
                guard let score = entry?.score else { return }
                completion(score)
            }
        }
    }
    
    private func handleAuthentication(_ viewController: UIViewController?, _ error: Error?) {
        if let error = error {
            return
        }
        
        if let viewController = viewController {
            delegate?.present(authenticationViewController: viewController)
            return
        }
        
        delegate?.didAuthenticate()
    }
}

extension LeaderboardService: LeaderboardScoreSender {
    func send(score: Int) {
        GKLeaderboard.submitScore(score,
                                  context: 0,
                                  player: currentPlayer,
                                  leaderboardIDs: [leaderboardId]
        ) {
            if let error = $0 {
                print("Failed to submit score!", error)
                return
            }
        }
    }
}
