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

private let tts = TTS()
private let questions = [
  ("cat", ["犬", "ねこ"], GameSelection.right),
  ("Good Morning?", ["おはよう。", "お元気ですか。"], GameSelection.left),
  ("purple", ["むらさき", "あかい"], GameSelection.left)
]

private var userActionPromise: Promise<GameSelection>?

private func nextQuestion(actionMeta: ActionMeta) {
  actionMeta.then(.nextQuestion)
  guard store.state.game.index < questions.count+1 else {
    actionMeta.then(.finishGame)
    return
  }

  actionMeta.then(.setGameStep(.questioning))

  let question = questions[store.state.game.index-1]
  actionMeta.then(.setCandidates(question.1))

  tts.say(question.0)
    .then { () -> Promise<GameSelection> in
      actionMeta.then(.setGameStep(.answering))
      userActionPromise = userAction()
      return userActionPromise!
    }
    .then { selection -> Promise<Void> in
      actionMeta.then(.setGameStep(.responding))
      let isCorrect = question.2 == selection
      actionMeta.then(.setIsCorect(isCorrect))
      return tts.say(isCorrect ? "Correct" : "Wrong")
    }
    .then {
      nextQuestion(actionMeta: actionMeta)
    }
}

private func speak(_ str: String) -> Promise<Void> {
  tts.say(str)
}

private func userAction() -> Promise<GameSelection> {
  Promise<GameSelection> { fulfill, reject in
    Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
      fulfill(.timeout)
    }
  }
}
