import SwiftUI

// global store variable
//  - [read]  by store.state
//  - [write] by store.dispatch(Action)
//  - [sync state with view] by onReceive(store.$state) in Views
let store = Store(state: AppState(),
                  reducer: myReducer,
                  middlewares: [
                    Logger(),
                    ComplexActionHandler()
                  ]
            )

@main
struct ToySRApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
