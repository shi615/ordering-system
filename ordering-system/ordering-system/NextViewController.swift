//
//  NextViewController.swift
//  ordering-system
//
//  Created by 石智光 on 2023/07/03.
//

import UIKit

class NextViewController: UIViewController {
    // 上部
    @IBOutlet private weak var menuSegmentedControl: UISegmentedControl! // メニュー類
    // 中部
    // -- 前菜・揚げ物
    @IBOutlet private weak var view0: UIView! // 前菜・揚げ物View
    @IBOutlet private weak var starterButton: UIButton! // 前菜Button
    @IBOutlet private weak var starterMenuTableView: UITableView! // 前菜TableView
    @IBOutlet private weak var friedButton: UIButton! // 揚げ物Button
    @IBOutlet private weak var friedMenuTableView: UITableView! // 揚げ物TableView
    // -- 主食・点心
    @IBOutlet private weak var view1: UIView!
    @IBOutlet private weak var stapleTableView: UITableView!
    @IBOutlet private weak var dessertTableView: UITableView!
    @IBOutlet private weak var stapleButton: UIButton!
    @IBOutlet private weak var dessertButton: UIButton!
    // -- 一品料理
    @IBOutlet private weak var view2: UIView!
    @IBOutlet private weak var meatTableView: UITableView!
    @IBOutlet private weak var vegetableTableView: UITableView!
    @IBOutlet private weak var seafoodTableView: UITableView!
    @IBOutlet private weak var grillTableView: UITableView!
    @IBOutlet private weak var meatButton: UIButton!
    @IBOutlet private weak var vegetableButton: UIButton!
    @IBOutlet private weak var seafoodButton: UIButton!
    @IBOutlet private weak var grillButton: UIButton!
    // -- 食べ飲み放題
    // -- 定食ランチ
    // -- 酒セット
    // 下部
    @IBOutlet private weak var historyTableView: UITableView! // 注文履歴View
    @IBOutlet private weak var historyButton: UIButton! // 注文履歴遷移Button
    @IBOutlet private weak var payButton: UIButton! // 会計遷移Button

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitViewIsHidden()
        setupView0Button()
        setupView1Button()
    }

    private func setupInitViewIsHidden() {
        // -- 前菜・揚げ物
        friedMenuTableView.isHidden = true
        // -- 主食・点心
        view1.isHidden = true
        dessertTableView.isHidden = true
        // -- 一品料理
        view2.isHidden = true
        vegetableTableView.isHidden = true
        seafoodTableView.isHidden = true
        grillTableView.isHidden = true
        // -- 食べ飲み放題
        // -- 定食ランチ
        // -- 酒セット
    }

    private func setupView0Button() {
        // 前菜Button
        starterButton.addAction(
            .init{ _ in
                self.starterMenuTableView.isHidden = false
                self.friedMenuTableView.isHidden = true
            },
            for: .touchUpInside
        )
        // 揚げ物Button
        friedButton.addAction(
            .init{ _ in
                self.starterMenuTableView.isHidden = true
                self.friedMenuTableView.isHidden = false
            },
            for: .touchUpInside
        )
    }

    private func setupView1Button() {
        // 主食Button
        stapleButton.addAction(
            .init{ _ in
                self.stapleTableView.isHidden = false
                self.dessertTableView.isHidden = true
            },
            for: .touchUpInside
        )
        // 点心Button
        dessertButton.addAction(
            .init{ _ in
                self.stapleTableView.isHidden = true
                self.dessertTableView.isHidden = false
            },
            for: .touchUpInside
        )
    }

    private func setupView2Button() {
        meatButton.addAction(
            .init{ _ in
                self.meatTableView.isHidden = false
                self.vegetableTableView.isHidden = true
                self.seafoodTableView.isHidden = true
                self.grillTableView.isHidden = true
            },
            for: .touchUpInside
        )
        vegetableButton.addAction(
            .init{ _ in
                self.meatTableView.isHidden = true
                self.vegetableTableView.isHidden = false
                self.seafoodTableView.isHidden = true
                self.grillTableView.isHidden = true
            },
            for: .touchUpInside
        )
        seafoodButton.addAction(
            .init{ _ in
                self.meatTableView.isHidden = true
                self.vegetableTableView.isHidden = true
                self.seafoodTableView.isHidden = false
                self.grillTableView.isHidden = true
            },
            for: .touchUpInside
        )
        grillButton.addAction(
            .init{ _ in
                self.meatTableView.isHidden = true
                self.vegetableTableView.isHidden = true
                self.seafoodTableView.isHidden = true
                self.grillTableView.isHidden = false
            },
            for: .touchUpInside
        )
    }
    
    @IBAction private func setupSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: //前菜・揚げ物
            view0.isHidden = false
            view1.isHidden = true
            view2.isHidden = true
        case 1: // 主食・点心
            view0.isHidden = true
            view1.isHidden = false
            view2.isHidden = true
        case 2: // 一品料理
            view0.isHidden = true
            view1.isHidden = true
            view2.isHidden = false
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
