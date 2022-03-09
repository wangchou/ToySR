import Foundation

//  publics:
//      - [create]        init(...)
//      - [read]          getter of state variable
//      - [update/delete] dispatch(Action)
class Store {
    @Published private(set) var state: AppState

    private let reducer: Reducer
    private var middlewares: [Middleware]

    init(state: AppState,
         reducer: @escaping Reducer,
         middlewares: [Middleware] = []) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares

        var next: ActionHandler = applyReducer
        for index in middlewares.indices.reversed() {
            self.middlewares[index].next = next
            next = self.middlewares[index].process
        }
    }

    func dispatch(_ action: Action) {
        if let middleware = middlewares.first {
            middleware.process(action)
        } else {
            applyReducer(action)
        }
    }

    private func applyReducer(_ action: Action) {
        state = reducer(state, action)
    }
}

