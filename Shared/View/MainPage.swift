import SwiftUI
import Foundation

struct MainPage: View {
  @State var counter = 0
  @State var imageName: String? = nil
  @State var gameScores: [Int] = []

  var body: some View {
    VStack {
      Color.pink
        .opacity(0.2)
        .frame(height: 50)
        .overlay { Text("Main Page").bold() }
      Spacer()
      Button(action: add) {
        Text("Add")
          .padding()
      }
      Button(action: loadImage) {
        Text("Load Image")
          .padding()
      }
      
      Text("Counter: \(counter)")
        .padding()
      Text("\(gameScores.count) played, highest score: \(gameScores.max() ?? 0)")
        .padding()
      
      if let imageName = imageName {
        if imageName == "Loading" {
          Text("Loading Image")
            .foregroundColor(.red)
            .frame(width: 100, height: 100)
        } else {
          Image(systemName: imageName)
            .resizable()
            .frame(width: 100, height: 100)
        }
      }
      Spacer()
      Button(action: gotoSetting) {
        Text("go to setting")
          .padding()
      }
      .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
      Button(action: startGame) {
        Text("start game")
          .padding()
      }
      .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
    }
    // do mapStateToProps/Selector/shouldComponentUpdate here
    .onReceive(store.$state) {
      //print("on receive \($0) [didSet]")
      self.counter = $0.counter
      self.imageName = $0.imageName
      self.gameScores = $0.gameScores
    }
  }
  
  // actions
  func add() {
    ~.increaseCounter
  }
  
  func loadImage() {
    ~.loadImage
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

