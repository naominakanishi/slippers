import StoreKit

final class StoreService: NSObject, SKProductsRequestDelegate {
    private let request: SKProductsRequest
    
    override init() {
        request = .init(productIdentifiers: ["Life", "cc.nimidesign.nijijump.life_pack"])
        super.init()
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest,
                         didReceive response: SKProductsResponse) {
        print("salve")
    }
}
