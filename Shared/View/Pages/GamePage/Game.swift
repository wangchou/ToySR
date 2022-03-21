struct Game: Codable, Hashable {
  var index = 0
  var step: GameStep = .questioning
  var candidates: [String] = []
  var isCorrect: Bool = false
  var score = 0
}

enum GameSelection: Int, Codable {
  case left
  case right
  case timeout
}

enum GameStep: Int, Codable {
  case questioning
  case answering
  case responding
}
