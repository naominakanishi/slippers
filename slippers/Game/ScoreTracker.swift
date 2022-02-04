import Foundation
protocol ScoreKeeper {
    var points: Int { get }
    var score: Int { get }
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
    
    private(set) var highScore: Int
    private var scoreBasis = 10
    private var scoreMultiplier = 1
    
    private let highScoreKey = "HIGH_SCORE"
    
    init() {
        highScore = 0
        highScore = loadHighscore()
    }
    
    func handleScore() {
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
