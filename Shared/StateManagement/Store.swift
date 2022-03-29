import Foundation
import Combine

//    subscribe   func              subscribe
// Store -> Views ----> GameStore     ----> Store
//                ----> SettingsStore ---->

class Store {
  @Published private(set) var state: AppState = AppState()

  private var cancellables: [AnyCancellable] = []

  private(set) var game = GameStore()
  private(set) var settings = SettingsStore()

  func gotoPage(_ page: Page) {
    state.page = page
    if page == .game {
      game.startGame()
    }
  }

  init() {
    var cancellable = game.$game.sink() {
      self.state.updateGame($0)
    }
    cancellables.append(cancellable)

    cancellable = settings.$settings.sink() {
      self.state.updateSettings($0)
    }
    cancellables.append(cancellable)

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(onVersionObjectChanged),
                                           name: versionChangedNotificationName,
                                           object: nil)
  }

  @objc
  func onVersionObjectChanged() {
    state.changed()
  }

  func addGameScores(score: Int) {
    state.gameScores.append(score)
  }
}
