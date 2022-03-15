import Foundation
import SwiftUI

enum Action: Hashable {
  // mainReducer
  case increaseCounter
  case setImageName(String)
  case gotoPage(Page)

  // settingReducer
  case setFontSize(CGFloat)

  // complexActionMiddleware
  case loadImage
}

extension Action {
  static prefix func ~(action: Self) {
    store.dispatch(action)
  }
}

// action with meta infos for devtools
// it created in store.dispatch
// and only be used in middleware chain
struct ActionMeta {
  let id: Int // serial number
  let parents: [Int]
  let action: Action

  var allIds: [Int] {
    parents + [id]
  }

  var prettyString: String {
    let parentChainStr = allIds.reduce("") {
      if $0 == "" {
        return "\($1)"
      }
      return $0 + " -> \($1)"
    }
    return "\(parentChainStr)\n\(action)"
  }
}
