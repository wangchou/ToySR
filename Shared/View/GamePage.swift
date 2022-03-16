import SwiftUI

enum UserSelection {
  case left
  case right
  case timeout
}

enum GameStep {
  case questioning
  case answering
  case responding
}

private var userActionContinuation: CheckedContinuation<Void, Never>?

struct GamePage: View {
  @State var questionIndex = 0
  @State var question: (String, String) = ("你好", "こんにちは")
  @State var candidate: (String, String) = ("早安", "おはようございます")
  @State var gameStep: GameStep = .questioning
  @State var answerOnL: Bool = false
  @State var selection: UserSelection = .timeout

  var body: some View {
    VStack {
      if gameStep == .answering {
        HStack {
          Button(action: { selectAnswer(.left)} ) { Text("Left") }
          Button(action: { selectAnswer(.right)} ) { Text("Right") }
        }
      }
      Text("\(questionIndex)/10")
        .padding()
        .task(priority: .userInitiated) {
          await nextQuestion()
        }
        .onReceive(store.$state) {
          questionIndex = $0.currentGame.index
        }
    }
  }

  func nextQuestion() async {
    if questionIndex < 4 {
      ~.nextQuestion
      gameStep = .questioning
      await speak("Question: hello")
      await speak("Candidates: left:aaa, right:bbb")

      gameStep = .answering
      await userAction()

      gameStep = .responding
      await showResponse()

      await nextQuestion()
    } else {
      ~.finishGame
    }
  }

  func selectAnswer(_ selection: UserSelection) {
    guard self.selection == .timeout else { return }
    self.selection = selection
    userActionContinuation?.resume(returning: ())
    store.log("userAction resume called")
    userActionContinuation = nil
  }

  func speak(_ str: String) async -> Void {
    return await withCheckedContinuation { continuation in
      DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
        store.log("\"\(str)\" is said")
        continuation.resume(returning: ())
      }
    }
  }

  func userAction() async -> Void {
    self.selection = .timeout
    userActionContinuation = nil
    let index = questionIndex
    return await withCheckedContinuation { continuation in
      userActionContinuation = continuation
      DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(5)) {
        guard self.selection == .timeout &&
              self.questionIndex == index else { return }
        store.log("Time out")
        store.log("userAction resume called")
        continuation.resume(returning: ())
      }
    }
  }

  func showResponse() async -> Void {
    store.log("selection: \(self.selection)")
  }
}
