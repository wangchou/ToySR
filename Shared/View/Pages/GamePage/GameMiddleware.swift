import Foundation
import Promises

let gameMiddleware: Middleware = { next in { actionMeta in
  switch actionMeta.action {
  case .gotoPage(let page):
    next(actionMeta)
    if page == .game {
      actionMeta.async(.startGame)
    }
  case .startGame:
    next(actionMeta)
    DispatchQueue.main.async {
      nextQuestion(from: actionMeta)
    }

  case .userSelect(let selection):
    userActionPromise?.fulfill(selection)

  default:
    next(actionMeta)
  }
}}

private let tts = TTS()
private let questions = [
  ("cat", ["犬", "ねこ"], GameSelection.right),
  ("Good Morning?", ["おはよう。", "お元気ですか。"], GameSelection.left),
  ("purple", ["むらさき", "あかい"], GameSelection.left)
]

private var userActionPromise: Promise<GameSelection>?

private func nextQuestion(from actionMeta: ActionMeta) {
  let dispatch = { (action: Action) in actionMeta.then(action) }

  dispatch(.nextQuestion)
  guard store.state.game.index < questions.count+1 else {
    dispatch(.finishGame)
    return
  }

  dispatch(.setGameStep(.questioning))

  let question = questions[store.state.game.index-1]
  dispatch(.setCandidates(question.1))

  tts.say(question.0)
    .then { () -> Promise<GameSelection> in
      dispatch(.setGameStep(.answering))
      userActionPromise = userAction()
      return userActionPromise!
    }
    .then { selection -> Promise<Void> in
      dispatch(.setGameStep(.responding))
      let isCorrect = question.2 == selection
      dispatch(.setIsCorect(isCorrect))
      return tts.say(isCorrect ? "Correct" : "Wrong")
    }
    .then {
      nextQuestion(from: actionMeta)
    }
}

private func userAction() -> Promise<GameSelection> {
  Promise<GameSelection> { fulfill, reject in
    Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
      fulfill(.timeout)
    }
  }
}
