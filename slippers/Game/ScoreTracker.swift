import Foundation
protocol ScoreKeeper {
    var points: Int { get }
    var score: Int { get }
    var canRestart: Bool { get }
}

protocol ScoreMultiplier {
    func multiply()
    func endMultiplication()
}

protocol Scorer {
    func handleScore()
}


typealias ScoreTrackerProtocol = ScoreKeeper &
                                 ScoreMultiplier &
                                 Scorer

final class ScoreTracker: ScoreTrackerProtocol {
    private(set) var points: Int = 0
    private(set) var score: Int = 0
    var canRestart: Bool {
        points > 0 && hasScored
    }
    
    private(set) var highScore: Int
    private var scoreBasis = 10
    private var scoreMultiplier = 1
    private var hasScored = false
    
    
    private let highScoreKey = "HIGH_SCORE"
    
    init() {
        highScore = 0
        highScore = loadHighscore()
    }
    
    func handleScore() {
        hasScored = true
        points += scoreBasis * scoreMultiplier
        score += points
        saveHighScoreIfNeeded()
    }
    
    func multiply() {
        points *= 2
        scoreMultiplier = 2
    }
    
    func endMultiplication() {
        scoreMultiplier = 1
    }
    
    func reset() {
        hasScored = false
        score = 0
        points = 0
    }
    
    func revive() {
        hasScored = false
    }
    
    private func saveHighScoreIfNeeded() {
        guard score > highScore
        else { return }
        highScore = score
        DispatchQueue.init(label: highScoreKey,
                           qos: .background).async {
            
            UserDefaults.standard.set(
                self.highScore,
                forKey: self.highScoreKey)
        }
    }
    
    private func loadHighscore() -> Int{
        UserDefaults.standard.integer(forKey: highScoreKey)
    }
}
