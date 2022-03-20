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

  // card game
  case startGame
  case nextQuestion
  case setGameStep(GameStep)
  case setGameSelection(GameSelection)
  case userSelect(GameSelection)
  case finishGame
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
