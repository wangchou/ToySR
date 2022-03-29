class Game: VersionObject, Codable {
  var index = 0 { didSet { changed() } }
  var step: GameStep = .questioning { didSet { changed() } }
  var candidates: [String] = [] { didSet { changed() } }
  var isCorrect: Bool = false { didSet { changed() } }
  var score = 0 { didSet { changed() } }
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
