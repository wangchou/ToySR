//
//  HistoryView.swift
//  ToySR
//
//  Created by Wangchou Lu on R 4/03/10.
//

import SwiftUI
import Foundation

struct HistoryView: View {
    @State var actionIndex: Int = -1
    @State var history: [(Action, AppState)] = []
    var body: some View {
        HStack(alignment: .top, spacing: 5) {
            // action lists
            ScrollView {
                VStack(spacing: 2) {
                    ForEach(history.indices, id: \.self) { i in
                        Color.white
                            .frame(width: 200, height: 40)
                            .border(actionIndex == i ? .red : .gray, width: 1)
                            .overlay {
                                Text(String(describing: history[i].0))
                            }
                            .onTapGesture {
                                actionIndex = i
                            }
                    }
                    Spacer()
                }
            }
            .font(.system(size: 12))
            .frame(width: 200, height: 400)
            .padding(5)
            .border(.gray, width: 0.5)

            // state
            ScrollView {
                HStack {
                    if actionIndex >= 0 {
                        Text("\(history[actionIndex].1.dumpString)")
                            .padding(3)
                    } else {
                        Text("")
                    }
                    Spacer()
                }
            }
            .frame(width: 400, height:400)
            .padding(5)
            .border(.gray, width: 0.5)
        }
        .padding(5)
        .onReceive(store.$history) {
            history = $0
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
