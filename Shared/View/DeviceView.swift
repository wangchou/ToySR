import SwiftUI

// macbook dpi 254, iPhone dpi 326
// let scale: CGFloat = 254/326

struct DeviceView: View {
  @Binding var device: Device
  
  @State var page: Page = .main
  @State var fontSize: CGFloat = 12
  
  var nextDevice: Device {
    let workingSet: [Device] = [
      .iPhoneSE1,
      .iPhone13,
    ]
    if let index = workingSet.firstIndex(where: { $0.name == device.name }) {
      return workingSet[(index+1) % workingSet.count]
    }
    print("cannot find current device")
    return device
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(device.name + " " + String(describing: device.size))
        .padding(.horizontal, 3)
        .foregroundColor(.white)
        .background(.red.opacity(0.7))
        .onTapGesture {
          device = nextDevice
        }
      VStack {
        switch page {
        case .main:
          MainPage()
        case .setting:
          SettingPage()
        case .game:
          GamePageByPromise()
        }
      }
      .frame(width: device.size.width,
             height: device.size.height)
      .border(.black, width: 0.5)
      .font(.system(size: fontSize))
    }
    .padding(10)
    .onReceive(store.$state) {
      self.page = $0.page
      self.fontSize = $0.settings.fontSize
    }
  }
}

struct DeviceView_Previews: PreviewProvider {
  static var previews: some View {
    DeviceView(device: .constant(.iPhoneSE2))
  }
}
