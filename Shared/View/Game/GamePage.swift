import SwiftUI

struct GamePage: View {
  @State var questionIndex = 0
  @State var gameStep: GameStep = .questioning
  @State var selection: GameSelection = .timeout

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
    }
    .task {
      ~.startGame
    }
    .onReceive(store.$state) {
      questionIndex = $0.currentGame.index
      gameStep = $0.currentGame.step
      selection = $0.currentGame.selection
    }
  }

  func selectAnswer(_ selection: GameSelection) {
    ~.userSelect(selection)
  }
}
