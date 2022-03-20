import Foundation
import Promises

let gameMiddleware: Middleware = { next in { actionMeta in
  switch actionMeta.action {
  case .startGame:
    next(actionMeta)
    DispatchQueue.main.async {
      nextQuestion(actionMeta: actionMeta)
    }

  case .userSelect(let selection):
    userActionPromise?.fulfill(selection)

  default:
    next(actionMeta)
  }
}}

var userActionPromise: Promise<GameSelection>?

private func nextQuestion(actionMeta: ActionMeta) {
  guard store.state.currentGame.index < 3 else {
    actionMeta.then(.finishGame)
    return
  }

  actionMeta.then(.nextQuestion)
  actionMeta.then(.setGameStep(.questioning))

  speak("Question: hello")
    .then {
      speak("Candidates: left:aaa, right:bbb")
    }
    .then { () -> Promise<GameSelection> in
      actionMeta.then(.setGameStep(.answering))
      userActionPromise = userAction()
      return userActionPromise!
    }
    .then { selection -> Void in
      actionMeta.then(.setGameSelection(selection))
      actionMeta.then(.setGameStep(.responding))
      nextQuestion(actionMeta: actionMeta)
    }
}

private func speak(_ str: String) -> Promise<Void> {
  Promise<Void> { fulfill, reject in
    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
      store.log("\"\(str)\" is said")
      fulfill(())
    }
  }
}

func userAction() -> Promise<GameSelection> {
  Promise<GameSelection> { fulfill, reject in
    Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
      fulfill(.timeout)
    }
  }
}
