import Foundation

//  publics:
//      - [create]        init(...)
//      - [read]          getter of state variable
//      - [update/delete] dispatch(Action)
class Store {
    @Published private(set) var state: AppState

    // devtools
    @Published private(set) var history: [(Action, AppState)] = []
    @Published private(set) var log: String = "console view\n"

    private let reducers: [Reducer]
    private var middlewares: [Middleware]
    private let queue = DispatchQueue(label: "action queue", qos: .userInitiated)

    init(state: AppState,
         reducers: [Reducer],
         middlewares: [Middleware] = []) {
        self.state = state
        self.reducers = reducers
        self.middlewares = middlewares

        var next: ActionHandler = applyReducers
        for index in middlewares.indices.reversed() {
            self.middlewares[index].next = next
            next = self.middlewares[index].process
        }
    }

    func print(_ str: String) {
        log += str + "\n"
    }

    func dispatch(_ action: Action) {
        store.print(String(describing: action))
        queue.sync {
            if let middleware = middlewares.first {
                middleware.process(action)
            } else {
                applyReducers(action)
            }
            history.append((action, state))
        }
    }

    private func applyReducers(_ action: Action) {
        for reducer in reducers {
            if let newState = reducer(state, action) {
                state = newState
                break
            }
        }
    }
}
