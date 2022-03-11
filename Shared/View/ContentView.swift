import SwiftUI
import Combine

struct ContentView: View {
    @State var device1: Device = .iPhoneSE1

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            DeviceView(device: $device1)
            //DeviceView(device: .iPhone13)
            DevtoolsView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
