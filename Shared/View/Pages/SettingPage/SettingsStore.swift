import Combine
import SwiftUI

class SettingsStore {
  @Published private(set) var settings = Settings()

  func setFontSize(_ fontSize: CGFloat) {
    settings.fontSize = fontSize
  }
}
