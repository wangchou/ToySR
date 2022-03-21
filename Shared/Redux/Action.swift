import Foundation
import SwiftUI

enum Action: Hashable {
  // routeReducer
  case gotoPage(Page)

  // settingReducer
  case setFontSize(CGFloat)

  // card game
  case startGame
  case nextQuestion
  case setCandidates([String])
  case setGameStep(GameStep)
  case userSelect(GameSelection)
  case setIsCorect(Bool)
  case finishGame

  // devtools
  case setAppStateFromHistory(AppState)
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

  static func +(lhs: ActionMeta, rhs: Action) {
    store.dispatch(rhs, lhs)
  }

  func then(_ action: Action) {
    store.dispatch(action, self)
  }
  
  func async(_ action: Action) {
    DispatchQueue.main.async {
      store.dispatch(action, self)
    }
  }
}
