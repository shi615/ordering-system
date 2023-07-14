//
//  MenuTableViewCell.swift
//  ordering-system
//
//  Created by 石智光 on 2023/07/14.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    private var imageNameString: String! // 画像名、UIImageViewはOverrideができないらしい

    @IBOutlet private weak var menuImageView: UIImageView!
    @IBOutlet private weak var menuNameLabel: UILabel!
    @IBOutlet private weak var menuPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
