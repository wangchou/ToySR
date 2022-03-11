//
//  Constants.swift
//  ToySR
//
//  Created by Wangchou Lu on R 4/03/10.
//

import Foundation

struct Device: Equatable {
    let name: String
    let size: CGSize

    static let iPhoneSE1 = Device(name: "iPhone SE 2016", size: CGSize(width: 320, height: 568))
    static let iPhoneSE2 = Device(name: "iPhone SE 2020", size: CGSize(width: 375, height: 667))
    static let iPhone13 = Device(name: "iPhone 13", size: CGSize(width: 390, height: 844))
    static let iPadMini2019 = Device(name: "iPad Mini 2019", size: CGSize(width: 1024, height: 768))
}
