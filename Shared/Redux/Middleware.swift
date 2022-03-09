import Foundation

typealias ActionHandler = (Action) -> Void

class Middleware {
    var next: ActionHandler? = nil
    func process(_ action: Action) {}
}

class Logger: Middleware {
    override func process(_ action: Action) {
        print("------")
        print("Action: \(action)")
        next?(action)
        print("State : \(action) \(store.state)")
    }
}

// handle complex action
// could be further divided into domains
// ex: ServiceApiHandler, SpeechRecognitionHandler...
class ComplexActionHandler: Middleware {
    override func process(_ action: Action) {
        switch action {
        case .loadImage:
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                store.dispatch(.setImageName("pencil.circle"))
            }
            next?(.setImageName("Loading"))

        default:
            next?(action)
        }
    }
}
