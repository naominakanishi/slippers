import StoreKit

final class StoreService: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver, SKRequestDelegate {
    private let lifePackId = "cc.nimidesign.nijijump.life_pack"
    private let request: SKProductsRequest
    private let paymentQueue = SKPaymentQueue.default()
    private let didBuyLifePack: () -> Void
    private let transactionFailed: () -> Void
    
    private var products: [SKProduct] = []
    private var lifePackProduct: SKProduct? {
        products.first(where: { $0.productIdentifier == lifePackId })
    }
    
    init(didBuyLifePack: @escaping () -> Void, transactionFailed: @escaping () ->  Void) {
        self.didBuyLifePack = didBuyLifePack
        self.transactionFailed = transactionFailed
        request = .init(productIdentifiers: [lifePackId])
        super.init()
        
        paymentQueue.add(self)
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest,
                         didReceive response: SKProductsResponse) {
        products = response.products
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions
            .filter { $0.transactionState == .purchased }
            .filter { $0.payment.productIdentifier == lifePackId }
            .forEach {
                didBuyLifePack()
                queue.finishTransaction($0)
            }
        transactions
            .filter { $0.transactionState == .failed }
            .forEach {
                transactionFailed()
                queue.finishTransaction($0)
            }
    }
    func buyLifePack() {
        guard let lifePackProduct = lifePackProduct
        else { return }
        paymentQueue.add(.init(product: lifePackProduct))
    }
    
}
