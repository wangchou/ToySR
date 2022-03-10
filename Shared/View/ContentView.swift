import SwiftUI
import Combine

struct ContentView: View {

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            DeviceView(device: .iPhoneSE)
            //DeviceView(device: .iPhone13)
            VStack(spacing: 0) {
                HistoryView()
                ConsoleView()
            }
            .alignmentGuide(VerticalAlignment.top) { _ in -10 }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
