import Foundation

typealias ActionMetaHandler = (ActionMeta) -> Void
typealias Middleware = (@escaping ActionMetaHandler) -> ActionMetaHandler

let logger: Middleware = { next in { actionMeta in
  print("------")
  print(actionMeta.prettyString)
  next(actionMeta)
  //store.state.prettyPrint()
}}
