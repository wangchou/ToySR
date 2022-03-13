import SwiftUI

// global store variable
//  - [read]  by store.state
//  - [write] by store.dispatch(Action)
//  - [sync state with view] by onReceive(store.$state) in Views
let store = Store(
    state: AppState(),
    reducers: [
        mainReducer,
        settingReducer,
        unhandledReducer
    ],
    middlewares: [
        logger,
        complexActionHandler
    ]
)

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
