import SwiftUI

private var userActionContinuation: CheckedContinuation<Void, Never>?

struct GamePage: View {
  @State var questionIndex = 0
  @State var gameStep: GameStep = .questioning
  @State var selection: UserSelection = .timeout

  var body: some View {
    VStack {
      if gameStep == .answering {
        HStack {
          Button(action: { selectAnswer(.left)} ) { Text("Left") }
          Button(action: { selectAnswer(.right)} ) { Text("Right") }
        }
      }

      Text("\(questionIndex)/4")
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
    userActionContinuation?.resume()
    store.log("userAction resume called")
    userActionContinuation = nil
  }

  func speak(_ str: String) async {
    return await withCheckedContinuation { cont in
      DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
        store.log("\"\(str)\" is said")
        cont.resume()
      }
    }
  }

  func userAction() async {
    self.selection = .timeout
    userActionContinuation = nil
    let index = questionIndex
    return await withCheckedContinuation { cont in
      userActionContinuation = cont
      DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(5)) {
        // continuation can only be called exactly once
        guard self.questionIndex == index else { return }
        selectAnswer(.timeout)
      }
    }
  }

  func showResponse() async -> Void {
    store.log("selection: \(self.selection)")
  }
}
