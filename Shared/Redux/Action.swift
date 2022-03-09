import Foundation
import SwiftUI

enum Action {
    // mainReducer
    case increaseCounter
    case setImageName(String)
    case gotoPage(Page)

    // settingReducer
    case setFontSize(CGFloat)

    // complexActionMiddleware
    case loadImage
}
