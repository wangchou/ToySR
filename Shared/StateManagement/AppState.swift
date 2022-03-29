import SwiftUI

enum Page: Codable {
  case main
  case setting
  case game
}

struct AppState: Codable, Hashable {
  // Route
  var page: Page = .main

  // MainPage
  var gameScores: [Int] = []

  // from SettingStore
  private(set) var settings = Settings()

  // from GameStore
  private(set) var game = Game()

  mutating func updateGame(_ game: Game) {
    self.game = game
  }

  mutating func updateSettings(_ settings: Settings) {
    self.settings = settings
  }

  private(set) var version: Int = 0

  mutating func changed() {
    version += 1
  }
}


// pretty print
extension AppState {
  var dumpString: String {
    var result = String()
    dump(self, to: &result)
    return result
  }
  
  func prettyPrint() {
    dump(self)
  }
  
  var prettyJSONString: NSString? {
    do {
      let jsonData = try JSONEncoder().encode(self)
      //let jsonString = String(data: jsonData, encoding: .utf8)!
      return jsonData.prettyPrintedJSONString
    } catch {
      print(error)
      return nil
    }
  }
}

// https://gist.github.com/cprovatas/5c9f51813bc784ef1d7fcbfb89de74fe
extension Data {
  var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
    guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
          let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
          let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
    
    return prettyPrintedString
  }
}
