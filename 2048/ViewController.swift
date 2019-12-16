//
//  ViewController.swift
//  2048
//
//  Created by Eric on 2019/12/11.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit
 
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    
    private let newGames: [String] = ["New Game (4 * 4)", "New Game (5 * 5)"]
    private var savedGame: GameData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "2048"
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.tableFooterView = UIView()
        self.view .addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.center.size.equalTo(self.view)
        }
        
        loadLatestGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        loadLatestGame()
    }
    
    func loadLatestGame() {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let sec = indexPath.section
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: NSStringFromClass(UITableViewCell.self))
        if savedGame != nil {
            if sec == 0 {
                if row == 0 {
                    cell.textLabel?.text = "Resume (\(savedGame!.lastUpdateTime!))"
                }
            } else if sec == 2 {
                if row == 0 {
                    cell.textLabel?.text = "All Archives"
                }
            }
        }
        if (savedGame == nil && sec == 0) || (savedGame != nil && sec == 1) {
            cell.textLabel?.text = newGames[row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc: UIViewController!
        let row = indexPath.row
        let sec = indexPath.section
 
        if savedGame != nil {
            if sec == 0 {
                if row == 0 {
                    vc = GameViewController(history: savedGame!)
                }
            } else if sec == 1 {
                if row == 0 {
                    vc = GameViewController()
                } else if row == 1 {
                    vc = GameViewController(dimension: 5)
                }
            } else if sec == 2 {
                if row == 0 {
                    vc = UIViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                }
            }
        } else {
            if sec == 0 {
                if row == 0 {
                    vc = GameViewController()
                 } else if row == 1 {
                    vc = GameViewController(dimension: 5)
                }
            }
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let newGameCount = 2 // 4 x 4; 5 x 5
        
        if savedGame != nil {
            if section == 0 {
                return 1
            } else if section == 1 {
                return newGameCount
            } else if section == 2 {
                return 1
            } else {
                return 0
            }
        } else {
            return newGameCount
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {

        if savedGame != nil {
            return 3;
        }
        return 1;
    }
    
    
}

