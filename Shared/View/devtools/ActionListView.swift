import SwiftUI

extension Action {
  var str: String {
    "\(self)"
  }
}

struct ActionListView: View {
  var demoCases: [Action] = [
    .increaseCounter,
    .setImageName("pencil.circle"),
    .gotoPage(.setting),
    .setFontSize(20),
    .setFontSize(12),
    .loadImage,
    .gotoPage(.game)
  ]
  
  var body: some View {
    ScrollView {
      VStack {
        ForEach(demoCases, id: \.self) { action in
          ActionButton(title: "\(action.str)",
                       isSelected: false,
                       onTap: {
            store.dispatch(action)
          })
        }
      }
    }
    .frame(width: 200, height: 700)
    .padding(5)
    .border(.gray, width: 0.5)
  }
}

struct ActionListView_Previews: PreviewProvider {
  static var previews: some View {
    ActionListView()
  }
}
