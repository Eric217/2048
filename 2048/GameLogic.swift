//
//  GameLogic.swift
//  2048
//
//  Created by Eric on 2019/12/14.
//  Copyright © 2019 none. All rights reserved.
//

import Foundation

enum SwipeDirection {
    case up, down, left, right
}

/// 视图 与 逻辑 传递信息
@objc protocol GameLogicDelegate {
    
    func insertUnit(at location: IndexPath, with value: Int);
    
    func moveOneUnit(from: IndexPath, to: IndexPath, value: Int);
    func moveTwoUnits(from a: IndexPath, and b: IndexPath, to: IndexPath, value:Int)
    
    // 上面三个是必须实现的，下面是选择实现的
    @objc optional func changeScore(addition: Int);
    @objc optional func gameOver();
    @objc optional func didPerformMove();
}
 

class GameLogicCenter {
    
    var numberArray: [Int]!
    var dimension: Int!
    
    weak var delegate: GameLogicDelegate?
    
    func startNewGame() {
        insertRandomUnit()
        insertRandomUnit()
    }
    
    func receiveSwipeCommand(_ direction: SwipeDirection) {
         
        func getSameGroups() -> [[(Int, Int)]] {
            // 是 dimension 个相同的操作
            var groups = [[(Int, Int)]]()
            
            for i in 0..<dimension {
                var group = [(Int, Int)]()
                for j in 0..<dimension {
                    
                    switch direction {
                    case .up:
                        group.append((j, i))
                    case .down:
                        group.append((dimension - 1 - j, i))
                    case .left:
                        group.append((i, j))
                    case .right:
                        group.append((i, dimension - 1 - j))
                    }
                }
                groups.append(group)
            }
            return groups
        }
        
        /// 下一个有值的单元的下标
        func getNextNumberIndex(after index: Int, of group: [(Int, Int)]) -> Int {
            if index == group.count - 1 {
                return -1
            }
            for i in (index+1)..<group.count {
                if numberArray.get(group[i], dimension: dimension) != 0 {
                    return i
                }
            }
            return -1
        }
         
        var movedFlag = false
        let groups = getSameGroups()
        
        for i in 0..<dimension { // for every group
            let group = groups[i]
            var busy = -1;
           
            for j in 0..<dimension {
                let currentValue = numberArray.get(group[j], dimension: dimension)
                if currentValue == 0 {
                    continue
                }
              
                let nextIndex = getNextNumberIndex(after: j, of: group)
                if nextIndex > 0
                    && currentValue == numberArray.get(group[nextIndex], dimension: dimension) {
                    // 需要合并。合并后实际只占用一个格子，加一
                    busy += 1
                 
                    movedFlag = true
                    let newValue = currentValue * 2
                    
                    // 合并两个格子到 j 处，或者到更前面的地方，二者的目的地都等于 busy，下一个相同格子也要置为0；不同点在 j 处是否置为0
                    numberArray.set(group[busy], dimension: dimension, value: newValue)
                    numberArray.set(group[nextIndex], dimension: dimension, value: 0)

                    if busy == j { // 合并两个格子到 j 处，只需要处理 next
                        delegate?.moveOneUnit(from: indexPath(group[nextIndex]), to: indexPath(group[busy]), value: newValue)
                    } else { // 合并两个格子到更前面的地方，原来两处都置为0
                        numberArray.set(group[j], dimension: dimension, value: 0)
                        delegate?.moveTwoUnits(from: indexPath(group[j]), and: indexPath(group[nextIndex]), to: indexPath(group[busy]), value: newValue)
                    }
                    delegate?.changeScore?(addition: newValue)

                } else { // 后面没格子了 或者 最近的格子没法合并
                    busy += 1
                    if busy != j { // 前面有空格子，需要挤过去，仅移动
                        numberArray.set(group[busy], dimension: dimension, value: currentValue)
                        numberArray.set(group[j], dimension: dimension, value: 0)
                        delegate?.moveOneUnit(from: indexPath(group[j]), to: indexPath(group[busy]), value: currentValue)
                        movedFlag = true
                    } else { // 原地不动
                        
                    }
                }
            }
        }
        
        if movedFlag {
            insertRandomUnit()
        }
    }
    
    private func indexPath(_ pair: (Int, Int)) -> IndexPath {
        return IndexPath(row: pair.0, section: pair.1)
    }
  
    private func insertRandomUnit() {
        
        func getEmptySlots() -> [(Int, Int)] {
            var result = [(Int, Int)]()
            for i in 0..<self.dimension {
                for j in 0..<self.dimension {
                    if numberArray[i * dimension + j] == 0 {
                        result.append((i, j))
                    }
                }
            }
            return result
        }
        
        func pickRandomSlot(from slots: [(Int, Int)]) -> (Int, Int) {
            assert(!slots.isEmpty)
            let randomIndex = Int(arc4random_uniform(UInt32(slots.count)))
            return slots[randomIndex]
        }
        
        func canMoveOn() -> Bool {
            // 只需要判断，一个格子的右边、下边是否相同就行了
            for i in 0..<dimension {
                for j in 0..<dimension {
                    let current = numberArray[i * dimension + j]
                    if j != dimension - 1 && current == numberArray[i * dimension + j + 1] {
                        return true
                    }
                    if i != dimension - 1 && current == numberArray[(i + 1) * dimension + j] {
                        return true
                    }
                }
            }
            return false
        }
        
        let emptySlots = getEmptySlots()
        let position = pickRandomSlot(from: emptySlots)
        /// 十分之一的概率插入4
        let insertValue = Int(arc4random_uniform(10)) == 6 ? 4 : 2
        
        numberArray.set(position, dimension: dimension, value: insertValue)
        delegate?.insertUnit(at: indexPath(position), with: insertValue)
        
        if emptySlots.count == 1 && !canMoveOn() { // 最后的空槽已经被占用，判断能不能继续游戏
            delegate?.gameOver?()
        }
    }
     
}
