import Foundation

typealias ActionMetaHandler = (ActionMeta) -> Void

class Middleware {
    var next: ActionMetaHandler? = nil
    func process(_ actionMeta: ActionMeta) {}
}

class Logger: Middleware {
    override func process(_ actionMeta: ActionMeta) {
        print("------")
        print("Action: \(actionMeta.action)")
        next?(actionMeta)
        store.state.prettyPrint()
    }
}

// handle complex action
// could be further divided into domains
// ex: ServiceApiHandler, SpeechRecognitionHandler...
class ComplexActionHandler: Middleware {
    override func process(_ actionMeta: ActionMeta) {
        switch actionMeta.action {
        case .loadImage:
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                store.dispatch(.setImageName("pencil.circle"), parents: actionMeta.allSN)
            }

            next?(.init(sn: -1,
                        parents: actionMeta.allSN,
                        action: .setImageName("Loading")))

        default:
            next?(actionMeta)
        }
    }
}
