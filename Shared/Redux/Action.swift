import Foundation

typealias Thunk = () -> Void

enum Action {
    case increaseCounter
    case thunk(Thunk)
}

