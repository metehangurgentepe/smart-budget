//
//  ScreenSize.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 29.03.2024.
//

import Foundation
import UIKit

struct ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}
