import SwiftUI
import Promises

var userActionPromise: Promise<UserSelection>?

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
        .task {
          store.log("google/promises")
          nextQuestion()
        }
        .onReceive(store.$state) {
          questionIndex = $0.currentGame.index
        }
    }
  }

  func nextQuestion() {
    guard questionIndex < 4 else {
      ~.finishGame
      return
    }

    ~.nextQuestion

    gameStep = .questioning
    speak("Question: hello")
      .then {
        speak("Candidates: left:aaa, right:bbb")
      }
      .then { () -> Promise<UserSelection> in
        gameStep = .answering
        userActionPromise = userAction()
        return userActionPromise!
      }
      .then { selection -> Void in
        self.selection = selection
        gameStep = .responding
        showResponse()
        nextQuestion()
      }
  }

  func selectAnswer(_ selection: UserSelection) {
    userActionPromise?.fulfill(selection)
  }

  func speak(_ str: String) -> Promise<Void> {
    Promise<Void> { fulfill, reject in
      Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
        store.log("\"\(str)\" is said")
        fulfill(())
      }
    }
  }

  func userAction() -> Promise<UserSelection> {
    Promise<UserSelection> { fulfill, reject in
      Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
        fulfill(.timeout)
      }
    }
  }

  func showResponse() -> Void {
    store.log("selection: \(self.selection)")
  }
}
