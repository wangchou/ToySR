import SwiftUI
import Combine

struct ContentView: View {
    @State var counter = 0

    var body: some View {
        VStack {
            Button(action: add) {
                Text("Add")
                    .padding()
            }
            Button(action: delayAdd) {
                Text("Add with 1 secs delay")
                    .padding()
            }

            Text("Counter: \(counter)")
        }
        .frame(minWidth: 480, minHeight: 320)
        // do mapStateToProps/Selector/shouldComponentUpdate here
        .onReceive(store.$state) {
            //print("on receive \($0) [didSet]")
            self.counter = $0.counter
        }
    }

    /* add this part to view if app needs old value and new value of state

    private var cancellable: AnyCancellable?

    init() {
        cancellable = store.$state
            .sink() {
                //                        old state      new state
                print ("init subscribe: \(store.state) -> \($0) [willSet]")
            }
    }
    */
}

// Actions
extension ContentView {
    func add() {
        store.dispatch(.increaseCounter)
    }

    func delayAdd() {
        store.dispatch(.thunk {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                store.dispatch(.increaseCounter)
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func debug() -> Self {
        print(Mirror(reflecting: self).subjectType)
        //print(String(reflecting: self))
        return self
    }
}
