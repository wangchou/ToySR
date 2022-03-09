import Foundation

//  publics:
//      - [create]        init(...)
//      - [read]          getter of state variable
//      - [update/delete] dispatch(Action)
class Store {
    @Published private(set) var state: AppState

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

    func dispatch(_ action: Action) {
        queue.sync {
            if let middleware = middlewares.first {
                middleware.process(action)
            } else {
                applyReducers(action)
            }
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
