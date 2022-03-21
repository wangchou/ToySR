typealias Reducer = (AppState, Action) -> AppState?

let routeReducer: Reducer = { state, action in
  var newState = state
  
  switch action {
  case .gotoPage(let page):
    newState.page = page
  default:
    return nil
  }
  
  return newState
}

let unhandledReducer: Reducer = { state, action in
  print("warning: \(action) is not handled")
  return nil
}
