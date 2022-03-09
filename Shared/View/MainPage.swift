import SwiftUI

struct MainPage: View {
    @State var counter = 0
    @State var imageName: String? = nil

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
        }
        // do mapStateToProps/Selector/shouldComponentUpdate here
        .onReceive(store.$state) {
            //print("on receive \($0) [didSet]")
            self.counter = $0.counter
            self.imageName = $0.imageName
        }
    }

    // actions
    func add() {
        store.dispatch(.increaseCounter)
    }

    func loadImage() {
        store.dispatch(.loadImage)
    }

    func gotoSetting() {
        store.dispatch(.gotoPage(.setting))
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

