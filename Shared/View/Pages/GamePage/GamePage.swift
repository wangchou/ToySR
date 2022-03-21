import SwiftUI

struct GamePage: View {
  @State var game = Game()

  var body: some View {
    VStack {
      Color.blue
        .opacity(0.2)
        .frame(height: 50)
        .overlay { Text("Vocalbulary Game").bold() }
      Spacer()
      if game.step == .answering {
        Text("Which one is spoken?")
        HStack {
          Button(action: { selectAnswer(.left)} ) { Text(game.candidates[0]) }
          Button(action: { selectAnswer(.right)} ) { Text(game.candidates[1]) }
        }
      }

      if game.step == .responding {
        Text(game.isCorrect ? "👍" : "💩")
      }

      Spacer()

      Text("Question No: \(game.index)")
      Text("Score: \(game.score)")
    }
    .onReceive(store.$state) {
      game = $0.game
    }
  }

  func selectAnswer(_ selection: GameSelection) {
    store.game.userSelect(selection: selection)
  }
}
