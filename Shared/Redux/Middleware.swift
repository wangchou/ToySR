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
let complexActionMiddleware: Middleware = { next in { actionMeta in
  switch actionMeta.action {
  case .loadImage:
    actionMeta.async(.setImageName("Loading"))
    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
      actionMeta.then(.setImageName("pencil.circle"))
    }

  default:
    next(actionMeta)
  }
}}
