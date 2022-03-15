import Foundation

typealias ActionMetaHandler = (ActionMeta) -> Void
typealias Middleware = (@escaping ActionMetaHandler) -> ActionMetaHandler

let logger: Middleware = { next in { actionMeta in
  print("------")
  print("Action: \(actionMeta.action)")
  next(actionMeta)
  store.state.prettyPrint()
}}

// handle complex action
// could be further divided into domains
// ex: ServiceApiHandler, SpeechRecognitionHandler...
let complexActionHandler: Middleware = { next in { actionMeta in
  switch actionMeta.action {
  case .loadImage:
    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
      store.dispatch(.setImageName("pencil.circle"), actionMeta)
    }
    
    next(.init(id: -1,
               parents: actionMeta.allIds,
               action: .setImageName("Loading")))
    
  default:
    next(actionMeta)
  }
}}
