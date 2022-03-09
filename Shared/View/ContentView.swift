import SwiftUI
import Combine

struct ContentView: View {
    @State var page: Page = .main
    @State var fontSize: CGFloat = 12

    var body: some View {
        VStack {
            switch page {
            case .main:
                MainPage()
            case .setting:
                SettingPage()
            }
        }
        .font(.system(size: fontSize))
        .frame(minWidth: 480, minHeight: 320)
        .onReceive(store.$state) {
            self.page = $0.page
            self.fontSize = $0.settings.fontSize
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
