//
//  GameViewController.swift
//  2048
//
//  Created by Eric on 2019/12/11.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit
import SnapKit

 
class GameViewController: UIViewController {
    
    private var gameData: GameData
    private var gameLogic = GameLogicCenter()
    private var gameUnits = Dictionary<IndexPath, UnitLabel>()
    
    private var lastHighest: Int! // 是历史最高，不包括本局

    /// New game with 4 dimension
    convenience init() {
        self.init(dimension: 4)
    }
    
    /// New game with designated dimension
    /// - parameter dimension: ranged 4 ~ 8
    init(dimension: Int) {
        assert(dimension > 3 && dimension < 9)
        self.gameData = GameData()
        
        super.init(nibName: nil, bundle: nil)
        
        self.gameData.dimension = dimension
        self.gameLogic.delegate = self
        self.gameLogic.dimension = dimension
        self.gameLogic.numberArray = self.gameData.numberArray
    }
    
    /// Load a saved game
    init(history: GameData) {
        history.validate()
        self.gameData = history
          
        // TODO: resume play
        
        super.init(nibName: nil, bundle: nil)
        
        self.gameLogic.delegate = self
        self.gameLogic.dimension = history.dimension
        self.gameLogic.numberArray = history.numberArray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 与 视图 有关的属性在这里声明
    private var backPanel = UIView()
    private var backUnits = [UIView]()
    
    private var paddingScale: CGFloat {
        switch self.dimension {
        case 4: return 0.14
        case 5: return 0.112
        default: return 0.09
        }
    }
    
    private var padding: CGFloat {
        return paddingScale * unitSize
    }
    private var cornerRadius: CGFloat {
        return padding * 0.35
    }
   
    private var marginScale: CGFloat {
        switch self.dimension {
        case 4: return 0.52
        case 5: return 0.36
        default: return 0.3
        }
    }
    private var unitSize: CGFloat {
        return min(UIScreen.main.bounds.height, UIScreen.main.bounds.width) / ((1 + paddingScale) * CGFloat(dimension) + paddingScale + marginScale * 2)
    }
    private var panelSize: CGFloat {
        return (padding + unitSize) * CGFloat(dimension) + padding
    }
    
    private var dimension: Int {
        return self.gameData.dimension
    }
    
    private var moveDuration: TimeInterval {
        return 0.15
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshLastHighest()
        
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.systemGray5
        } else {
            self.view.backgroundColor = UIColor.white
        }
        
        setupCenterPanel()
        setupSwipeGestures()
        resume()
        
        
    }
    
    func setupSwipeGestures() {
        let upSwipe = UISwipeGestureRecognizer(target:self, action: #selector(upCommand(_:)))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = .up
        view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target:self, action: #selector(downCommand(_:)))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = .down
        view.addGestureRecognizer(downSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target:self, action: #selector(leftCommand(_:)))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target:self, action: #selector(rightCommand(_:)))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func upCommand(_ swiper: UISwipeGestureRecognizer) {
        gameLogic.receiveSwipeCommand(.up)
    }
    @objc func leftCommand(_ swiper: UISwipeGestureRecognizer) {
        gameLogic.receiveSwipeCommand(.left)
    }
    @objc func downCommand(_ swiper: UISwipeGestureRecognizer) {
        gameLogic.receiveSwipeCommand(.down)
    }
    @objc func rightCommand(_ swiper: UISwipeGestureRecognizer) {
        gameLogic.receiveSwipeCommand(.right)
    }
    
    func resume() {
        func isNewGame() -> Bool {
            return self.gameData.step == 0
        }
        
        if isNewGame() {
            self.gameLogic.startNewGame()
        } else {
            
        }
    }
    
    func setupCenterPanel() {
        backPanel.backgroundColor = UIColor(displayP3Red: 184/255.0, green: 176/255.0, blue: 163/255.0, alpha: 1)
        backPanel.layer.cornerRadius = cornerRadius * 1.5
        self.view.addSubview(backPanel)
        
        backPanel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(0)
            make.width.height.equalTo(self.panelSize)
        }
        
        for i in 0..<dimension {
            let iy = padding + CGFloat(i) * (padding + unitSize)
            
            for j in 0..<dimension {
                let jx = padding + CGFloat(j) * (padding + unitSize)
                let backUnit = UIView(frame: CGRect(x:jx, y: iy, width: unitSize, height: unitSize))
                backUnit.backgroundColor = UIColor(displayP3Red: 200.0/255, green: 194.0/255, blue: 181.0/255, alpha: 1)
                backUnit.layer.cornerRadius = cornerRadius
                backPanel.addSubview(backUnit)
                backUnits.append(backUnit)
            }
        }
    }

// 以后做转屏时用 
//    override func updateViewConstraints() {
//        super .updateViewConstraints()
//    }
//
//    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//        super .willTransition(to: newCollection, with: coordinator)
//    }
//
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super .viewWillTransition(to: size, with: coordinator)
//    }
    
    @objc func resetButtonDidClick(_ button: UIButton) {
        let alert = UIAlertController(title: "RESET", message: "Current game will be deleted permanently.", preferredStyle: .alert)
        let resetAction = UIAlertAction(title:"Confirm", style: .destructive, handler: { _ in
            self.resetGame()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(resetAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func resetGame() {
        refreshLastHighest()
        //TODO:  if current cached, remove it
        self.gameData = GameData()
        self.gameData.dimension = dimension
        self.gameLogic.numberArray = self.gameData.numberArray
               
        for entry in gameUnits {
            entry.value.removeFromSuperview()
        }
        gameUnits.removeAll()
        
        //TODO: other views
        
        self.resume()
    }
    
    private func saveGame() {
        
    }
    
    private func refreshLastHighest() {
        self.lastHighest = DataSaver.highestScore(dimension)
        //TODO:  high label
    }
    
}

// MARK: - GameLogicDelegate
extension GameViewController: GameLogicDelegate {
     
    func changeScore(addition: Int) {

        self.gameData.score += addition
        if self.gameData.score > self.lastHighest {
            DataSaver.updateHighestScore(gameData.score, dimension: dimension)
            //TODO:  high label
        }

        //TODO: - score label
        
    }
     
    func didPerformMove() {
        self.gameData.step += 1
        
        
        
        if gameData.step % 10 == 0 { // 虽然app退出时会保存游戏，但是以防万一，十步一存
            self.saveGame()
        }
    }
    
    func gameOver() {
        let message = lastHighest < gameData.score ?
            "Congrats! New Record!" : "Sorry: You've lost the game."
                
        let lostView = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        let resetAction = UIAlertAction(title:"Try Again", style: .cancel, handler: { _ in
            self.resetGame()
        })
        let cancelAction = UIAlertAction(title: "Got it", style: .default, handler: nil)
        let exitAction = UIAlertAction(title: "Exit", style: .default, handler: { _ in
            //TODO:  if current cached, remove it
            self.dismiss(animated: false, completion: nil)
        })
        lostView.addAction(resetAction)
        lostView.addAction(cancelAction)
        lostView.addAction(exitAction)
        present(lostView, animated: true, completion: nil)
    }
    
    // required game logic
    
    func insertUnit(at location: IndexPath, with value: Int) {
        let finalFrame = backUnits.get((location.row, location.section), dimension: dimension).frame
        let unit = UnitLabel(frame: CGRect(x: finalFrame.origin.x + finalFrame.size.width/2, y: finalFrame.origin.y + finalFrame.size.height/2, width: 0, height: 0))
        unit.value = value
        unit.layer.cornerRadius = finalFrame.size.width/2
        backPanel.addSubview(unit)
        gameUnits[location] = unit
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .beginFromCurrentState, animations: {
            unit.frame = finalFrame
            unit.layer.cornerRadius = self.cornerRadius
        }, completion: { finished in
            if !finished {
                return
            }
        })
    }
    
    func moveOneUnit(from: IndexPath, to: IndexPath, value: Int) {
      
        guard let unit = gameUnits[from] else {
            assert(false)
        }
        
        let endUnit = gameUnits[to]
        let shouldPop = endUnit != nil
        let finalFrame = backUnits[to.row * dimension + to.section].frame
         
        gameUnits.removeValue(forKey: from)
        gameUnits[to] = unit
        
        if shouldPop {
            backPanel.bringSubviewToFront(unit)
        }

        UIView.animate(withDuration: moveDuration, delay: 0.0, options: .beginFromCurrentState, animations: {
            unit.frame = finalFrame
            unit.value = value
        }, completion: { finished in
            endUnit?.removeFromSuperview()
            if !shouldPop || !finished {
                return
            }
        })
    }
    
    func moveTwoUnits(from a: IndexPath, and b: IndexPath, to: IndexPath, value: Int) {
        // B 一定是最远的，让 B 变化，覆盖 A
        guard let unitA = gameUnits[a] else {
            assert(false)
        }
        guard let unitB = gameUnits[b] else {
            assert(false)
        }
  
        let finalFrame = backUnits[to.row * dimension + to.section].frame
        let endUnit = gameUnits[to]
        endUnit?.removeFromSuperview()
         
        gameUnits.removeValue(forKey: a)
        gameUnits.removeValue(forKey: b)
        gameUnits[to] = unitB
        
        backPanel.bringSubviewToFront(unitB)
         
        UIView.animate(withDuration: moveDuration, delay: 0.0, options: .beginFromCurrentState, animations: {
            unitA.frame = finalFrame
            unitB.frame = finalFrame
            unitB.value = value
        }, completion: { finished in
            unitA.removeFromSuperview()
            if !finished {
                return
            }
        })
    }
    
}
