import Foundation

protocol LivesServiceDelegate: AnyObject {
    func didBuyLives()
    func didTransactionFail()
}

final class LivesService {
    // MARK: - Properties
    private lazy var storeService = StoreService {
        self.purchaseSucceed()
    } transactionFailed: {
        self.delegate?.didTransactionFail()
    }
    private let livesCountKey = "lives_count_key"
    private(set) var livesCount = 0
    
    weak var delegate: LivesServiceDelegate?
    
    // MARK: - Initialization
    
    init() {
        loadLivesFromUserDefaults()
        _ = storeService
        
    }
    
    // MARK: - Public API
    
    func purchase() {
        storeService.buyLifePack()
    }
    
    func consume() {
        livesCount -= 1
        persistLivesCount()
    }
    
    // MARK: - Helpers
    
    private func purchaseSucceed() {
        livesCount = 3
        persistLivesCount()
        delegate?.didBuyLives()
    }
    
    // MARK: - Persistance
    
    private func persistLivesCount() {
        UserDefaults.standard.set(livesCount, forKey: livesCountKey)
    }
    private func loadLivesFromUserDefaults() {
        livesCount = UserDefaults.standard.integer(forKey: livesCountKey)
    }
}
