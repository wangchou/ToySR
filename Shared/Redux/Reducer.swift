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
  switch action {
  case .startGame:
    newState.page = .game
    newState.currentGame = CurrentGame()
  case .nextQuestion:
    newState.currentGame.index += 1
  case .finishGame:
    newState.page = .main
    newState.gameScores.append(newState.currentGame.score)
  default:
    return nil
  }
  return newState
}

let unhandledReducer: Reducer = { state, action in
  print("warning: \(action) is not handled")
  return nil
}
