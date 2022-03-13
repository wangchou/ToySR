import Foundation

//  publics:
//      - [create]        init(...)
//      - [read]          getter of state variable
//      - [update/delete] dispatch(Action)
//      - [log]           log to devtools
class Store {
    @Published private(set) var state: AppState

    private let reducers: [Reducer]
    private let queue = DispatchQueue(label: "action queue", qos: .userInitiated)
    private var _dispatch: ActionMetaHandler!

    init(state: AppState,
         reducers: [Reducer],
         middlewares: [Middleware] = []) {
        self.state = state
        self.reducers = reducers

        _dispatch = middlewares
            .reversed()
            .reduce(applyReducers) { next, createMiddleware in
                createMiddleware(next)
            }
    }

    func dispatch(_ action: Action, _ parent: ActionMeta? = nil) {
        queue.sync {
            let actionMeta = ActionMeta(id: nextId,
                                        parents: parent?.allIds ?? [],
                                        action: action)
            _dispatch(actionMeta)
            history.append((actionMeta, state))
        }
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

    //----------------------------------------------------------------
    // for devtools
    @Published private(set) var history: [(ActionMeta, AppState)] = []
    @Published private(set) var log = "console view\n"

    private var actionCount = 0
    func log(_ str: String) {
        log += str + "\n"
    }

    private var nextId: Int {
        actionCount += 1
        return actionCount
    }
}
