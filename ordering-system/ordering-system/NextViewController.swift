//
//  NextViewController.swift
//  ordering-system
//
//  Created by 石智光 on 2023/07/03.
//

import UIKit

class NextViewController: UIViewController {
    @IBOutlet private weak var menuSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var recommendedMenuView: UIView!
    @IBOutlet private weak var lunchMenuView: UIView!
    @IBOutlet private weak var menuImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        lunchMenuView.isHidden = true
        menuImageView.image = UIImage(named: "FirstMenu")
        
    }
    
    @IBAction private func setupSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            recommendedMenuView.isHidden = false
            lunchMenuView.isHidden = true
        case 1:
            recommendedMenuView.isHidden = true
            lunchMenuView.isHidden = false
        case 2:
            return
        case 3:
            return
        case 4:
            return
        default:
            return
        }
    }
}
