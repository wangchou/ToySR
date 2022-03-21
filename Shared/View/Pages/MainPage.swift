import SwiftUI
import Foundation

struct MainPage: View {
  @State var gameScores: [Int] = []

  var body: some View {
    VStack {
      Color.pink
        .opacity(0.2)
        .frame(height: 50)
        .overlay { Text("Main Page").bold() }

      Spacer()

      Button(action: startGame) {
        Text("start game")
          .padding()
      }

      Spacer()

      Text("\(gameScores.count) games played, best score: \(gameScores.max() ?? 0)")
        .padding()

      Button(action: gotoSetting) {
        Text("setting")
          .padding()
      }
    }
    // do mapStateToProps/Selector/shouldComponentUpdate here
    .onReceive(store.$state) {
      //print("on receive \($0) [didSet]")
      self.gameScores = $0.gameScores
    }
  }

  func gotoSetting() {
    ~.gotoPage(.setting)
  }

  func startGame() {
    ~.gotoPage(.game)
  }
}

struct MainPage_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

