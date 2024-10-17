//
//  Item.swift
//  InputSourceSwitcher
//
//  Created by 福田裕作 on 2024/10/18.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
