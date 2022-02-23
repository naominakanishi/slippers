import AppTrackingTransparency

final class AdPermissionService {
    func request(completion: @escaping () -> Void) {
        ATTrackingManager.requestTrackingAuthorization { result in
            completion()
        }
    }
}
