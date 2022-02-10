import Foundation

final class LivesService {
    // MARK: - Properties
    
    private let livesCountKey = "lives_count_key"
    private(set) var livesCount = 0
    
    // MARK: - Initialization
    
    init() {
        loadLivesFromUserDefaults()
    }
    
    // MARK: - Public API
    
    func purchase() {}
    func consume() {
        persistLivesCount()
    }
    
    // MARK: - Helpers
    
    private func purchaseSucceed() {
        persistLivesCount()
    }
    
    // MARK: - Persistance
    
    private func persistLivesCount() {
        UserDefaults.standard.set(livesCount, forKey: livesCountKey)
    }
    private func loadLivesFromUserDefaults() {
        livesCount = UserDefaults.standard.integer(forKey: livesCountKey)
    }
}
