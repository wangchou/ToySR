import SwiftUI
import Combine

struct ContentView: View {
  @State var device1: Device = .iPhoneSE1
  @State var device2: Device = .iPhoneSE2
  
  var body: some View {
    HStack(alignment: .top, spacing: 0) {
      DeviceView(device: $device1)
      //DeviceView(device: $device2)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
