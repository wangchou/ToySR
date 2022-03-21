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
