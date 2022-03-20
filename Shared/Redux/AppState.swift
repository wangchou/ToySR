import SwiftUI

struct Settings: Codable {
  var fontSize: CGFloat = 12
}

enum Page: Codable {
  case main
  case setting
  case game
}

struct CurrentGame: Codable {
  var index = 0
  var selection: GameSelection = .timeout
  var step: GameStep = .questioning
  var score = 0
}

struct AppState: Codable {
  var page: Page = .main
  
  var counter: Int = 0
  var imageName: String? = nil
  
  var settings = Settings()

  // Game
  var currentGame = CurrentGame()
  var gameScores: [Int] = []
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
