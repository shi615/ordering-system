//
//  NextViewController.swift
//  ordering-system
//
//  Created by 石智光 on 2023/07/03.
//

import UIKit

protocol NextViewTotalPriceDelegate: AnyObject {
    func didPressButton(orderedMenu: [CellData])
}

class NextViewController: UIViewController {
    // 上部
    @IBOutlet weak var menuSegmentedControl: UISegmentedControl!
    private var views: [MenuView] = []
    @IBOutlet private weak var view1: MenuView!
    @IBOutlet private weak var view2: MenuView!
    @IBOutlet private weak var view3: MenuView!
    @IBOutlet private weak var view4: MenuView!
    @IBOutlet private weak var view5: MenuView!
    @IBOutlet private weak var view6: MenuView!
    @IBOutlet private weak var historyView: UIView!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var payButtonView: UIView!
    @IBOutlet private weak var payButton: UIButton!

    private let menuTitles = ["一品料理", "麺・飯", "飲み物・デザート", "食べ放題・飲み放題", "定食・ランチ", "酒セット"]
    private let view3Buttons = ["ノンアルコール", "アルコール", "デザート"]
    private let view2Buttons = ["麺類", "飯類"]
    private let view1Buttons = ["前菜", "揚げ物", "肉料理", "野菜料理", "海鮮料理", "鍋鉄板", "点心", "お粥・スープ"]
    private let view4Buttons = ["食べ放題", "飲み放題"]
    private let view5Buttons = ["定食", "ランチ"]
    private let view6Buttons = ["料理", "プラス"]
//    private let menuTitles = ["メニュー1", "メニュー2", "メニュー3", "メニュー4", "メニュー5", "メニュー6"]
//    private let view1Buttons = ["サブメニュー1", "サブメニュー2", "サブメニュー3"]
//    private let view2Buttons = ["サブメニュー1", "サブメニュー2"]
//    private let view3Buttons = ["サブメニュー1", "サブメニュー2", "サブメニュー3", "サブメニュー4", "サブメニュー5", "サブメニュー6", "サブメニュー7", "サブメニュー8"]
//    private let view4Buttons = ["サブメニュー1", "サブメニュー2"]
//    private let view5Buttons = ["サブメニュー1", "サブメニュー2"]
//    private let view6Buttons = ["サブメニュー1", "サブメニュー2"]
    private var allViewButtons: [[String]] = []
    private var imageNames: [[[String]]] = [
        [["枝豆_300", "棒棒鳥_580", "春巻き_700", "キャベツ_500", "野菜サラダ_580", "もやしサラダ_600"]],
        [],
        [],
        [],
        [],
        []
    ]
    private var orderedMenu: [CellData] = []
    private var historyCollectionView: UICollectionView!
    weak var nextViewTotalPriceDelegate: NextViewTotalPriceDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRoundCorner(20.0)
        initSetup()
        insertMenuData()
    }

    private func initSetup() {
        
        let font = UIFont.systemFont(ofSize: 20) // Set the desired font size
        let textColor = UIColor.black // Set the desired text color

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor
        ]

        menuSegmentedControl.setTitleTextAttributes(attributes, for: .normal)
        menuSegmentedControl.backgroundColor = .systemOrange


        allViewButtons.append(view1Buttons)
        allViewButtons.append(view2Buttons)
        allViewButtons.append(view3Buttons)
        allViewButtons.append(view4Buttons)
        allViewButtons.append(view5Buttons)
        allViewButtons.append(view6Buttons)

        views.append(view1)
        views.append(view2)
        views.append(view3)
        views.append(view4)
        views.append(view5)
        views.append(view6)

        for i in 0..<views.count {
            if i != 0 {
                views[i].isHidden = true
            }
            insertButtons(views[i], allViewButtons[i])
            views[i].cellDelegate = self
            views[i].backgroundColor = .systemOrange
        }

        setupViewsTitle(menuTitles)

        setupHistoryCollectionView()

        setupPayButtonAction()

        setupTotalPriceView()
    }

    private func setupTotalPriceView() {
        totalPriceLabel.textAlignment = .center
        totalPriceLabel.numberOfLines = 0
        totalPriceLabel.text = "総金額"
        totalPriceLabel.font = UIFont.systemFont(ofSize: 25)
    }

    private func setupPayButtonAction() {
        payButton.addAction(
            .init { _ in
                let storyboard = UIStoryboard(name: "Pay", bundle: nil)
                if let payViewController = storyboard.instantiateViewController(withIdentifier: "PayViewController") as? PayViewController {
                    payViewController.orderedMenu = self.orderedMenu
                    self.navigationController?.pushViewController(payViewController, animated: true)
                }
                self.nextViewTotalPriceDelegate?.didPressButton(orderedMenu: self.orderedMenu)
            },
            for: .touchUpInside
        )
    }

    private func setupHistoryCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        historyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        historyCollectionView.setCollectionViewLayout(layout, animated: true)
        
        historyCollectionView.register(
            HistoryCollectionViewCell.self,
            forCellWithReuseIdentifier: HistoryCollectionViewCell.identifier
        )
        historyCollectionView.dataSource = self
        historyCollectionView.delegate = self
        
        historyCollectionView.layer.cornerRadius = 20.0
        historyCollectionView.layer.masksToBounds = true
        historyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        historyView.addSubview(historyCollectionView)
        
        NSLayoutConstraint.activate([
            historyCollectionView.topAnchor.constraint(equalTo: historyView.topAnchor, constant: 10),
            historyCollectionView.bottomAnchor.constraint(equalTo: historyView.bottomAnchor, constant: -10),
            historyCollectionView.leadingAnchor.constraint(equalTo: historyView.leadingAnchor, constant: 10),
            historyCollectionView.trailingAnchor.constraint(equalTo: historyView.trailingAnchor, constant: -120)
        ])
    }

    private func insertMenuData() {
        // Asset名：メニュー番号_サブメニュー番号_商品名_値段.png、０から始めないといけない！！
        if imageNames.count == 0 {
            return
        }
        for i in 0..<views.count {
            if imageNames[i].count == 0 {
                continue
            }
            for j in 0..<imageNames[i].count {
                if imageNames[i][j].count == 0 {
                    continue
                }
                for imageName in imageNames[i][j] {
                    let components = imageName.split(separator: "_")

                    if components.count >= 2 {
                        let title = String(components[0])
                        let price = Int(String(components[1])) ?? 0

                        if UIImage(named: imageName) != nil {
                            views[i].setupCellData(collectionViewNumber: j, imageName: imageName, title: title, price: price)
                        }
                    }
                }
            }
        }
    }

    private func setupViewsTitle( _ titles: [String]) {
        if titles.count == views.count {
            for index in 0..<views.count {
                menuSegmentedControl.setTitle( titles[index], forSegmentAt: index)
            }
        }
    }

    private func insertButtons( _ view: MenuView, _ buttons: [String]) {
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
        payButtonView.layer.cornerRadius = cornerRadius
        payButtonView.layer.masksToBounds = true
    }

    private func showTotalPrice() {
        var totalPrice = 0
        for i in orderedMenu {
            totalPrice += i.price
        }
        totalPriceLabel.font = UIFont.systemFont(ofSize: 25)
        totalPriceLabel.text = "総金額" + "\n\(totalPrice)"
    }
}

extension NextViewController: MenuViewCellDelegate {
    func didPressCell(collectionViewIndex: Int, cellIndex: Int, cellData: CellData) {
        orderedMenu.append(cellData)
        historyCollectionView.reloadData()
        showTotalPrice()
    }
}

extension NextViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderedMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCollectionViewCell.identifier, for: indexPath) as? HistoryCollectionViewCell else {
            fatalError("Failed to dequeue MenuCollectionViewCell.")
        }
        let cellData = orderedMenu[indexPath.row]
        cell.configure(with: cellData.image, title: "", number: cellData.price)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.frame.height - 20,
            height: collectionView.frame.height - 20
        )
    }
}
