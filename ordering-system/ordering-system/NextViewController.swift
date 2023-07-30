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
//    @IBOutlet private weak var historyButtonView: UIView!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var payButtonView: UIView!
    @IBOutlet private weak var payButton: UIButton!
    
    private let menuTitles = ["飲み物・デザート", "麺・飯", "一品料理", "食べ放題・飲み放題", "定食・ランチ", "酒セット"]
    private let view1Buttons = ["ノンアルコール", "アルコール", "デザート"]
    private let view2Buttons = ["麺類", "飯類"]
    private let view3Buttons = ["前菜", "揚げ物", "肉料理", "野菜料理", "海鮮料理", "鍋鉄板", "点心", "お粥・スープ"]
    private let view4Buttons = ["食べ放題", "飲み放題"]
    private let view5Buttons = ["定食", "ランチ"]
    private let view6Buttons = ["料理", "プラス"]
    private var allViewButtons: [[String]] = []
    private var imageNames: [[[String]]] = [
        [],
        [],
        [["枝豆_300", "棒棒鳥_580", "春巻き_700", "キャベツ_500", "野菜サラダ_580", "もやしサラダ_600"]],
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
        }
        // テスト用
        view1.backgroundColor = .systemBlue
        view2.backgroundColor = .systemRed
        view3.backgroundColor = .systemOrange
        view4.backgroundColor = .systemCyan
        view5.backgroundColor = .systemMint
        view6.backgroundColor = .systemGray

        setupViewsTitle(menuTitles)

        setupHistoryCollectionView()

        setupPayButtonAction()

        setupTotalPriceView()
    }

    private func setupTotalPriceView() {
        totalPriceLabel.textAlignment = .center
        totalPriceLabel.numberOfLines = 0
        totalPriceLabel.text = "総金額"
    }

    private func setupPayButtonAction() {
        payButton.addAction(
            .init { _ in
//                let storyboard = UIStoryboard(name: "Pay", bundle: nil)
//                if let vc = storyboard.instantiateInitialViewController() {
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//                self.nextViewTotalPriceDelegate?.didPressButton(orderedMenu: self.orderedMenu)
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
        // layout.itemSize = CGSize(width: collectionView.frame.width - 20, height: collectionView.frame.width - 20)
        // layout.minimumLineSpacing = 0
        // layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        historyCollectionView.setCollectionViewLayout(layout, animated: true)
        
        historyCollectionView.register(
            MenuCollectionViewCell.self,
            forCellWithReuseIdentifier: MenuCollectionViewCell.identifier
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

        //        let label = UILabel()
        //        label.text = String(collectionViews.count)
        //        label.translatesAutoresizingMaskIntoConstraints = false
        //        collectionView.addSubview(label)
        //        label.backgroundColor = .systemCyan
        //        NSLayoutConstraint.activate([
        //            label.widthAnchor.constraint(equalTo: widthAnchor, constant: 10),
        //            label.heightAnchor.constraint(equalToConstant: 100)
        //        ])
    }

    private func insertMenuData() {
        // Asset名：メニュー番号_サブメニュー番号_商品名_値段.png、０から始めないといけない！！
//        let title = "キャベツ"
//        let price = 800
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
        // view1.setupCellData(collectionViewNumber: 2, imageName: "キャベツ_800", title: "キャベツ", price: 800) // いけるぞ！これ
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
//        historyButtonView.layer.cornerRadius = cornerRadius
//        historyButtonView.layer.masksToBounds = true
        payButtonView.layer.cornerRadius = cornerRadius
        payButtonView.layer.masksToBounds = true
    }

    private func showTotalPrice() {
        var totalPrice = 0
        for i in orderedMenu {
            totalPrice += i.price
        }
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
        // return orderedMenu.count
        return orderedMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.identifier, for: indexPath) as? MenuCollectionViewCell else {
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
