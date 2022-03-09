import SwiftUI

struct Settings {
    var fontSize: CGFloat = 12
}

enum Page {
    case main
    case setting
}

struct AppState {
    var page: Page = .main

    var counter: Int = 0
    var imageName: String? = nil

    var settings = Settings()
}
