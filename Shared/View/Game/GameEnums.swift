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
