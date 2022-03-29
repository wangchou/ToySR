import Foundation
import Promises

private var userActionPromise: Promise<GameSelection>?

class GameStore {
  @Published private(set) var game = Game()

  private let tts = TTS()
  private let questions = [
    ("cat", ["犬", "ねこ"], GameSelection.right),
    ("Good Morning?", ["おはよう。", "お元気ですか。"], GameSelection.left),
    ("purple", ["むらさき", "あかい"], GameSelection.left)
  ]

  func startGame() {
    game = Game()
    nextQuestion()
  }

  func userSelect(selection: GameSelection) {
    userActionPromise?.fulfill(selection)
  }

  private func finishGame() {
    store.gotoPage(.main)
    store.addGameScores(score: game.score)
  }

  private func nextQuestion() {
    game.index += 1
    game.changed()
    guard game.index < questions.count+1 else {
      finishGame()
      return
    }

    game.step = .questioning

    let question = questions[store.state.game.index-1]
    game.candidates = question.1
    game.changed()

    tts.say(question.0)
      .then { () -> Promise<GameSelection> in
        self.game.step = .answering
        self.game.changed()
        userActionPromise = self.userAction()
        return userActionPromise!
      }
      .then { selection -> Promise<Void> in
        self.game.step = .responding
        let isCorrect = question.2 == selection
        self.game.isCorrect = isCorrect
        self.game.score += isCorrect ? 10 : 0
        self.game.changed()
        return self.tts.say(isCorrect ? "Correct" : "Wrong")
      }
      .then {
        self.nextQuestion()
      }
  }

  private func userAction() -> Promise<GameSelection> {
    Promise<GameSelection> { fulfill, reject in
      Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
        fulfill(.timeout)
      }
    }
  }
}
