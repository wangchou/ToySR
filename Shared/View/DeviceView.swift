//
//  DeviceView.swift
//  ToySR
//
//  Created by Wangchou Lu on R 4/03/10.
//

import SwiftUI

// macbook dpi 254, iPhone dpi 326
// let scale: CGFloat = 254/326

struct DeviceView: View {
    var device: Device = Device.iPhoneSE

    @State var page: Page = .main
    @State var fontSize: CGFloat = 12

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(device.name + " " + String(describing: device.size))
                .padding(3)
                .foregroundColor(.white)
                .background(.pink.opacity(0.5))
            VStack {
                switch page {
                case .main:
                    MainPage()
                case .setting:
                    SettingPage()
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
        DeviceView()
    }
}
