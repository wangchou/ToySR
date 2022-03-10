//
//  ConsoleView.swift
//  ToySR
//
//  Created by Wangchou Lu on R 4/03/10.
//

import SwiftUI

struct ConsoleView: View {
    @State var log: String = "empty console\ntest"
    var body: some View {
        ScrollView() {
            Text(log)
                .foregroundColor(.white)
                .padding(8)
        }
        .frame(width: 625, alignment: .topLeading)
        .background(.black)
        .border(.gray, width: 0.5)
        .padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5))
        .frame(height: 300)
        .onReceive(store.$log) {
            log = $0
        }
    }
}

struct ConsoleView_Previews: PreviewProvider {
    static var previews: some View {
        ConsoleView()
    }
}
