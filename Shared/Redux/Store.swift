import Foundation

//  publics:
//      - [create]        init(...)
//      - [read]          getter of state variable
//      - [update/delete] dispatch(Action)
class Store {
    @Published private(set) var state: AppState

    // devtools
    @Published private(set) var history: [(ActionMeta, AppState)] = []
    @Published private(set) var log: String = "console view\n"

    private var actionCount = 0
    private let reducers: [Reducer]
    private var middlewares: [Middleware]
    private let queue = DispatchQueue(label: "action queue", qos: .userInitiated)

    init(state: AppState,
         reducers: [Reducer],
         middlewares: [Middleware] = []) {
        self.state = state
        self.reducers = reducers
        self.middlewares = middlewares

        var next: ActionMetaHandler = applyReducers
        for index in middlewares.indices.reversed() {
            self.middlewares[index].next = next
            next = self.middlewares[index].process
        }
    }

    func print(_ str: String) {
        log += str + "\n"
    }

    func dispatch(_ action: Action, parents: [Int] = []) {
        queue.sync {
            let actionMeta = ActionMeta(sn: getActionSN(),
                                        parents: parents,
                                        action: action)

            if let middleware = middlewares.first {
                middleware.process(actionMeta)
            } else {
                applyReducers(actionMeta)
            }
            history.append((actionMeta, state))
        }
    }

    func getActionSN() -> Int {
        actionCount += 1
        return actionCount
    }

    private func applyReducers(_ actionMeta: ActionMeta) {
        let action = actionMeta.action
        for reducer in reducers {
            if let newState = reducer(state, action) {
                state = newState
                break
            }
        }
    }
}
