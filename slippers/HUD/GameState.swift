enum GameState {
    case initialScreen
    case playing
    case gameOver
}

protocol StateRenderer {
    func render(state: GameState)
}

final class GameStateMachine {
    private var renderers: [StateRenderer] = []
    var currentState = GameState.initialScreen {
        didSet {
            updateState()
        }
    }
    
    func addRenderer (renderer: StateRenderer) {
        renderers.append(renderer)
    }
    
    private func updateState() {
        renderers.forEach{
            $0.render(state: currentState)
        }
    }
}
