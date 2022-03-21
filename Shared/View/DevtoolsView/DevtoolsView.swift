import SwiftUI

struct DevtoolsView: View {
  var body: some View {
    HStack(alignment: .top, spacing: 0) {
      ActionListView()
        .alignmentGuide(VerticalAlignment.top) { _ in -10 }
      VStack(spacing: 0) {
        HistoryView()
        ConsoleView()
      }
      .alignmentGuide(VerticalAlignment.top) { _ in -5 }
    }
  }
}

struct DevtoolsView_Previews: PreviewProvider {
  static var previews: some View {
    DevtoolsView()
  }
}
