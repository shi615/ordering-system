//
//  NextViewController.swift
//  ordering-system
//
//  Created by 石智光 on 2023/07/03.
//

import UIKit

class NextViewController: UIViewController {
    @IBOutlet private weak var menuSegmentedControl: UISegmentedControl! // メニュー類
    @IBOutlet private weak var view0: UIView! // 前菜・揚げ物ビュー
    @IBOutlet private weak var menuTableView0: UITableView! // 前菜・揚げ物
    @IBOutlet private weak var historyTableView: UITableView! // 注文履歴ビュー
    @IBOutlet private weak var historyButton: UIButton! // 注文履歴遷移ボタン
    @IBOutlet private weak var payButton: UIButton! // 会計遷移ボタン

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func setupSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: //前菜・揚げ物
            return
        case 1: // 主食・点心
            return
        case 2: // 一品料理
            return
        case 3: // 食べ飲み放題
            return
        case 4: // 定食ランチ
            return
        case 5: // 酒セット
            return
        default:
            return
        }
    }
}
