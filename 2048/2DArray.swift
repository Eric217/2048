//
//  2DArray.swift
//  2048
//
//  Created by Eric on 2019/12/16.
//  Copyright © 2019 none. All rights reserved.
//

import Foundation

extension Array {
    
    func get(_ index: (Int, Int), dimension: Int) -> Element {
        return self[index.0 * dimension + index.1]
    }
    
    mutating func set(_ index: (Int, Int), dimension: Int, value: Element) {
        self[index.0 * dimension + index.1] = value
    }
      
}
