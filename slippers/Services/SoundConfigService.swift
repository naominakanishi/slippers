import Foundation

protocol SoundConfigServiceDelegate: AnyObject {
    func musicConfigDidChange()
}

final class SoundConfigService {
    
    private let soundFlagKey = "soundEnabled"
    private let musicFlagKey = "musicEnabled"
    
    private(set) var isSoundOn: Bool
    private(set) var isMusicOn: Bool
    
    weak var delegate: SoundConfigServiceDelegate?
    
    init() {
        isSoundOn = UserDefaults.standard.bool(forKey: soundFlagKey)
        isMusicOn = UserDefaults.standard.bool(forKey: musicFlagKey)
    }
    
    func updateSoundState(_ isOn: Bool) {
        isSoundOn = isOn
        UserDefaults.standard.set(isOn, forKey: soundFlagKey)
    }
    
    func updateMusicState(_ isOn: Bool) {
        isMusicOn = isOn
        UserDefaults.standard.set(isOn, forKey: musicFlagKey)
        delegate?.musicConfigDidChange()
    }
}
