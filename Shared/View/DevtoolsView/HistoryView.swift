import SwiftUI
import Foundation


struct HistoryView: View {
  @State var entry: (ActionMeta, AppState)?
  @State var history: [(ActionMeta, AppState)] = []

  var body: some View {
    HStack(alignment: .top, spacing: 5) {
      // action lists
      ScrollView {
        ScrollViewReader { value in
          VStack(spacing: 0) {
            ForEach(history, id: \.0.id) { entry in
              ActionButton(
                title: entry.0.prettyString,
                isSelected: self.entry?.0.id == entry.0.id,
                onTap: {},
                onHover: {
                  if $0 {
                    self.entry = entry
                    ~.setAppStateFromHistory(entry.1)
                  } else {
                    self.entry = history.last
                    ~.setAppStateFromHistory(history.last!.1)
                  }
                }
              )
            }
            .onChange(of: history.count) { _ in
              value.scrollTo(history.last!.0.id)
            }
            Spacer()
          }
        }
      }
      .font(.system(size: 12))
      .frame(width: 200, height: 400)
      .padding(5)
      .border(.gray, width: 0.5)
      
      // state
      ScrollView {
        HStack {
          if let entry = self.entry {
            Text("\(entry.0.prettyString)\n---\n\(entry.1.dumpString)")
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
      entry = $0.last
    }
  }
}

struct HistoryView_Previews: PreviewProvider {
  static var previews: some View {
    HistoryView()
  }
}
