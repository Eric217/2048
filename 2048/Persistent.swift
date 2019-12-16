//
//  Persistent.swift
//  2048
//
//  Created by Eric on 2019/12/16.
//  Copyright © 2019 none. All rights reserved.
//

import Foundation


class DataSaver: NSObject {
    
    static func updateHighestScore(_ score: Int, dimension: Int) {
        UserDefaults.standard.set(score, forKey: "score\(dimension)")
    }
    
    static let highestScore: (Int) -> Int = { dimension in
        return UserDefaults.standard.integer(forKey: "score\(dimension)")
    }
    
}
