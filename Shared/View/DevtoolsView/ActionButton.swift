import SwiftUI

struct ActionButton: View {
  var title: String
  var isSelected: Bool
  var onTap: () -> Void
  var onHover: (Bool) -> Void

  @State var isHovering: Bool = false

  var body: some View {
    Color.white
      .frame(width: 200, height: 40)
      .overlay {
        if isHovering {
          Color.pink.opacity(0.2)
        } else {
          Color.white
        }
      }
      .border(isSelected ? .red : .gray, width: 1)
      .overlay(alignment: .leading) {
        Text(title)
          .padding(.leading, 5)
          .font(.system(size: 10))
      }
      .onHover {
        isHovering = $0
        self.onHover($0)
      }
      .onTapGesture { onTap() }
  }
}

struct ActionButton_Previews: PreviewProvider {
  static var previews: some View {
    ActionButton(title: "title", isSelected: false, onTap: {}, onHover: {_ in }, isHovering: false)
  }
}
