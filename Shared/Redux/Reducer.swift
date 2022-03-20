typealias Reducer = (AppState, Action) -> AppState?

let mainReducer: Reducer = { state, action in
  var newState = state
  
  switch action {
  case .increaseCounter:
    newState.counter += 1
  case .setImageName(let name):
    newState.imageName = name
  case .gotoPage(let page):
    newState.page = page
  default:
    return nil
  }
  
  return newState
}

let settingReducer: Reducer = { state, action in
  var newState = state
  
  switch action {
  case .setFontSize(let size):
    newState.settings.fontSize = size
  default:
    return nil
  }
  
  return newState
}

let gameReducer: Reducer = { state, action in
  var newState = state
  var game = state.currentGame
  switch action {
  case .startGame:
    game = CurrentGame()
  case .nextQuestion:
    game.index += 1
  case .setGameStep(let step):
    game.step = step
  case .setGameSelection(let selection):
    game.selection = selection
  case .finishGame:
    newState.page = .main
    newState.gameScores.append(newState.currentGame.score)
  default:
    return nil
  }
  newState.currentGame = game
  return newState
}

let unhandledReducer: Reducer = { state, action in
  print("warning: \(action) is not handled")
  return nil
}
