import SwiftUI

enum Page: Codable {
  case main
  case setting
  case game
}

struct AppState: Codable {
  // Route
  var page: Page = .main

  // MainPage
  var gameScores: [Int] = []

  // SettingPage
  var settings = Settings()

  // GamePage
  var game = Game()
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
