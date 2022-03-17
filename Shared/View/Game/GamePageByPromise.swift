import SwiftUI
import Promises

private var fulfillUserSelection: ((UserSelection) -> Void)?

struct GamePageByPromise: View {
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
          nextQuestion()
        }
        .onReceive(store.$state) {
          questionIndex = $0.currentGame.index
        }
    }
  }

  func nextQuestion() {
    if questionIndex < 4 {
      ~.nextQuestion

      do {
        gameStep = .questioning
        try awaitPromise(speak("Question: hello"))
        try awaitPromise(speak("Candidates: left:aaa, right:bbb"))

        gameStep = .answering
        selection = try awaitPromise(userAction())

        gameStep = .responding
        showResponse()
        
        nextQuestion()
      } catch {
        print(#function, error)
      }
    } else {
      ~.finishGame
    }
  }

  func selectAnswer(_ selection: UserSelection) {
    fulfillUserSelection?(selection)
  }

  func speak(_ str: String) -> Promise<Void> {
    Promise<Void>(on: .global()) { fulfill, reject in
      Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
        store.log("\"\(str)\" is said")
        fulfill(())
      }
    }
  }

  func userAction() -> Promise<UserSelection> {
    Promise<UserSelection>(on: .global()) { fulfill, reject in
      fulfillUserSelection = fulfill
      Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
        fulfill(.timeout)
      }
    }
  }

  func showResponse() -> Void {
    store.log("selection: \(self.selection)")
  }
}
