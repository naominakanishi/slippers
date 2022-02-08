import GoogleMobileAds

protocol AdServiceDelegate: AnyObject {
    func showError()
    func rewardUser()
}

final class AdService {
    
    private var currentAd: GADRewardedAd?

    weak var delegate: AdServiceDelegate?
    
    func showRewardAd(in viewController: UIViewController) {
        #if DEBUG
        let adID = "ca-app-pub-3940256099942544/1712485313"
        #else
        let adID = "ca-app-pub-6389028471739991/8186145034"
        #endif

        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: adID, request: request) { ad, error in
            self.currentAd = ad
            guard let ad = ad else {
                print ("Error downloading ad, \(error)")
                self.delegate?.showError()
                return
            }
            ad.present(fromRootViewController: viewController) {
                print("Restart game")
                self.delegate?.rewardUser()
            }
        }
    }
}
