//
//  Game.swift
//  2048
//
//  Created by Eric on 2019/12/11.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit

class GameData: NSObject {
    
    /// 分数
    var score: Int = 0
    /// 有效滑动次数
    var step: Int = 0
    /// 耗时
    var time: TimeInterval = 0
    
    /// 空的块为 0
    var numberArray: [Int]!
    var dimension: Int! {
        didSet {
            self.numberArray = Array(repeating: 0, count: self.dimension * self.dimension)
        }
    }
    
    let createTime = Date()
    var lastUpdateTime: Date?
    
    func validate() {
        assert(dimension > 3 && dimension < 9)
        assert(time >= 0)
        assert(numberArray != nil)
        assert(score >= 0)
        assert(step >= 0)
    }
     
}
