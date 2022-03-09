typealias Reducer = (AppState, Action) -> AppState

let myReducer: Reducer = { state, action in
    var mutatingState = state

    switch action {
    case .increaseCounter:
        mutatingState.counter += 1
    default:
        break
    }

    return mutatingState
}
