import Combine

class Game: VersionObject {
  @Published var index = 0
  @Published var step: GameStep = .questioning
  @Published var candidates: [String] = []
  @Published var isCorrect: Bool = false
  @Published var score = 0
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
