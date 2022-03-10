//
//  Constants.swift
//  ToySR
//
//  Created by Wangchou Lu on R 4/03/10.
//

import Foundation

struct Device {
    let name: String
    let size: CGSize

    static let iPhoneSE = Device(name: "iPhone SE", size: CGSize(width: 320, height: 568))
    static let iPhone13 = Device(name: "iPhone 13", size: CGSize(width: 390, height: 844))
}
