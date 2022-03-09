import SwiftUI

struct SettingPage: View {
    @State var fontSize: CGFloat = 12

    var body: some View {
        VStack {
            Color.green
                .opacity(0.2)
                .frame(height: 50)
                .overlay { Text("Setting Page").bold() }
            Spacer()
            HStack {
                Button(action: decreaseFontSize) { Text("-").padding() }
                Text("font size: \(Int(fontSize))px")
                Button(action: increaseFontSize) { Text("+").padding() }
            }
            Spacer()
            Button(action: gotoMain) {
                Text("go to Main")
                    .padding()
            }
        }
        .onReceive(store.$state) {
            self.fontSize = $0.settings.fontSize
        }
    }

    // actions
    func increaseFontSize() {
        store.dispatch(.setFontSize(fontSize + 2.0))
    }

    func decreaseFontSize() {
        store.dispatch(.setFontSize(fontSize - 2.0))
    }

    func gotoMain() {
        store.dispatch(.gotoPage(.main))
    }
}

struct SettingPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingPage()
    }
}
