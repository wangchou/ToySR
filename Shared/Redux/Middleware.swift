typealias ActionHandler = (Action) -> Void

class Middleware {
    var next: ActionHandler? = nil
    func process(_ action: Action) {}
}

class Logger: Middleware {
    override func process(_ action: Action) {
        switch action {
        default:
            print("------")
            print("Action: \(action)")
            next?(action)
            print("New State: \(store.state)")
            break
        }
    }
}

class ThunkMiddleware: Middleware {
    override func process(_ action: Action) {
        switch action {
        case .thunk(let function):
            function()
        default:
            next?(action)
            break
        }
    }
}
