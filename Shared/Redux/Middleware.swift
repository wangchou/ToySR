import Foundation

typealias ActionMetaHandler = (ActionMeta) -> Void
typealias Middleware = (@escaping ActionMetaHandler) -> ActionMetaHandler

let logger: Middleware = { next in { actionMeta in
  print("------")
  print("Action: \(actionMeta.action)")
  next(actionMeta)
  store.state.prettyPrint()
}}
