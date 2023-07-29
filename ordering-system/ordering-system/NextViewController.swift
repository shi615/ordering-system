//
//  NextViewController.swift
//  ordering-system
//
//  Created by 石智光 on 2023/07/03.
//

import UIKit

class NextViewController: UIViewController {
    // 上部
//    @IBOutlet private weak var menuSegmentedControl: UISegmentedControl!
    @IBOutlet weak var menuSegmentedControl: UISegmentedControl!
    private var views: [MenuView] = []
    @IBOutlet private weak var view1: MenuView!
    @IBOutlet private weak var view2: MenuView!
    @IBOutlet private weak var view3: MenuView!
    @IBOutlet private weak var view4: MenuView!
    @IBOutlet private weak var view5: MenuView!
    @IBOutlet private weak var view6: MenuView!
    @IBOutlet private weak var historyView: UIView!
    @IBOutlet private weak var historyButtonView: UIView!
    @IBOutlet private weak var payButtonView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRoundCorner(20.0)
        initSetup()
    }

    private func initSetup() {
        // 各ViewにButtonを挿入
        insertButton(
            view1,
            [
                "ノンアルコール",
                "アルコール",
                "デザート"
            ]
        )
        insertButton(
            view2,
            [
                "麺類",
                "飯類"
            ]
        )
        insertButton(
            view3,
            [
                "前菜",
                "揚げ物",
                "肉料理",
                "野菜料理",
                "海鮮料理",
                "鍋鉄板",
                "点心",
                "お粥・スープ",
            ]
        )
        insertButton(
            view4,
            [
                "食べ放題",
                "飲み放題"
            ]
        )
        insertButton(
            view5,
            [
                "定食",
                "ランチ"
            ]
        )
        insertButton(
            view6,
            [
                "酒",
                "料理",
                "プラス"
            ]
        )

        views.append(view1)
        views.append(view2)
        views.append(view3)
        views.append(view4)
        views.append(view5)
        views.append(view6)
        for i in 1..<views.count {
            views[i].isHidden = true
        }
        // テスト用
        view1.backgroundColor = .systemBlue
        view2.backgroundColor = .systemRed
        view3.backgroundColor = .systemOrange
        view4.backgroundColor = .systemCyan
        view5.backgroundColor = .systemMint
        view6.backgroundColor = .systemGray

        setupViewsTitle(
            [
                "飲み物・デザート",
                "麺・飯",
                "一品料理",
                "食べ放題・飲み放題",
                "定食・ランチ",
                "酒セット"
            ]
        )
    }

    private func setupViewsTitle( _ titles: [String]) {
        if titles.count == views.count {
            for index in 0..<views.count {
                menuSegmentedControl.setTitle( titles[index], forSegmentAt: index)
            }
        }
    }

    private func insertButton( _ view: MenuView, _ buttons: [String]) {
        for title in buttons {
            view.insertButton(buttonTitle: title)
        }
    }

    @IBAction func hidden(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        for i in 0..<views.count {
            views[i].isHidden = i != index ? true : false
        }
    }
    private func setupRoundCorner(_ cornerRadius: CGFloat) {
        historyView.layer.cornerRadius = cornerRadius
        historyView.layer.masksToBounds = true
        historyButtonView.layer.cornerRadius = cornerRadius
        historyButtonView.layer.masksToBounds = true
        payButtonView.layer.cornerRadius = cornerRadius
        payButtonView.layer.masksToBounds = true
    }
}
