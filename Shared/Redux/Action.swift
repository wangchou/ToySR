import Foundation

enum Action {
    // simple actions (handled by reducer)
    case increaseCounter
    case setImageName(String)

    // complex actions (handled by complexActionMiddleware)
    case loadImage
}
