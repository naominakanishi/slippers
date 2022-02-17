import AVFoundation

final class MusicService {
    
    private let backgroundSong: AVAudioPlayer?
    private let soundConfig: SoundConfigService
    init(soundConfig: SoundConfigService) {
        self.soundConfig = soundConfig
        guard let path = Bundle.main.path(forResource: "background-music.mp3", ofType:nil),
              let audioPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        else {
            backgroundSong = nil
            return
        }
        
        backgroundSong = audioPlayer
        self.soundConfig.delegate = self
        backgroundSong?.numberOfLoops = -1
    }
    
    func play() {
        guard soundConfig.isMusicOn else { return }
        backgroundSong?.play()
    }
    
    func pause() {}
    
    func stop() {
        backgroundSong?.stop()
    }
}

extension MusicService: SoundConfigServiceDelegate {
    func musicConfigDidChange() {
        if soundConfig.isMusicOn {
            play()
        } else {
            stop()
        }
    }
}
