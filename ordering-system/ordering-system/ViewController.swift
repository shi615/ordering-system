//
//  ViewController.swift
//  ordering-system
//
//  Created by 石智光 on 2023/07/03.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "mien"
        setupTitleLabel()
        setupButton()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "中華美食　味縁"
    }

    private func setupButton() {
        startButton.addAction(
            .init { _ in
                let storyboard = UIStoryboard(name: "Next", bundle: nil)
                if let vc = storyboard.instantiateInitialViewController() {
                    self.navigationController?.pushViewController(vc, animated: true)
                }            },
            for: .touchUpInside
        )
    }
}
