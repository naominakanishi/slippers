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
    private var lastState: GameState = .initialScreen
    var currentState = GameState.initialScreen {
        willSet {
            lastState = currentState
        }
        didSet {
            updateState()
        }
    }
    
    func addRenderer (renderer: StateRenderer) {
        renderers.append(renderer)
    }
    
    private func updateState() {
        guard currentState != lastState else { return }
        renderers.forEach{
            $0.render(state: currentState)
        }
    }
}
