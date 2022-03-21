typealias Reducer = (AppState, Action) -> AppState?

let mainReducer: Reducer = { state, action in
  var newState = state
  
  switch action {
  case .gotoPage(let page):
    newState.page = page
  case .setAppStateFromHistory(let appState):
    newState = appState
  default:
    return nil
  }
  
  return newState
}

let unhandledReducer: Reducer = { state, action in
  print("warning: \(action) is not handled")
  return nil
}
