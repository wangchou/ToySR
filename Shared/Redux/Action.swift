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

// action with meta info
// it created in store.dispatch
// and only be used in middleware chain
struct ActionMeta {
    let sn: Int // serial number
    let parents: [Int] // parent actions's serial number
    let action: Action

    var allSN: [Int] {
        var result : [Int] = parents
        result.append(sn)
        return result
    }

    var prettyString: String {
        let parentChainStr = allSN.reduce("") {
            if $0 == "" {
                return "\($1)"
            }
            return $0 + " -> \($1)"
        }
        return "\(parentChainStr)\n\(action)"
    }
}
