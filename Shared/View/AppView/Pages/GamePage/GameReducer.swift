let gameReducer: Reducer = { state, action in
  var newState = state
  var game = state.game
  switch action {
  case .startGame:
    game = Game()
  case .nextQuestion:
    game.index += 1
  case .setCandidates(let candidates):
    game.candidates = candidates
  case .setGameStep(let step):
    game.step = step
  case .setIsCorect(let isCorrect):
    game.isCorrect = isCorrect
    game.score += isCorrect ? 10 : 0
  case .finishGame:
    newState.page = .main
    newState.gameScores.append(newState.game.score)
  default:
    return nil
  }
  newState.game = game
  return newState
}
