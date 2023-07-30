//
//  PayViewController.swift
//  ordering-system
//
//  Created by 石智光 on 2023/07/30.
//

import UIKit

class PayViewController: UIViewController {
    var orderedMenu: [CellData]?
    @IBOutlet private weak var restartButton: UIButton!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    static var idendifier = "PayViewController"

    override func viewDidLoad() {
        super.viewDidLoad()

        showTotalPrice()
        setupRestartButton()
    }

    private func showTotalPrice() {
        totalPriceLabel.numberOfLines = 0
        totalPriceLabel.textAlignment = .center
        var totalPrice = 0
        if let orderedMenu = orderedMenu {
            for i in orderedMenu {
                totalPrice += i.price
            }
            totalPriceLabel.text = "会計\n" + "￥\(totalPrice)"
        }
    }

    private func setupRestartButton() {
        restartButton.setTitle("新規注文", for: .normal)
        restartButton.addAction(
            .init{ _ in
                self.navigationController?.popToRootViewController(animated: true)
            },
            for: .touchUpInside)
    }
}
