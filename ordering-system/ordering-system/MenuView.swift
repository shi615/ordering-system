import UIKit

struct CellData {
    var image: UIImage
    var title: String
    var price: Int
    
    init(image: UIImage, title: String, price: Int) {
        self.image = image
        self.title = title
        self.price = price
    }
    
    mutating func changePrice(newPrice: Int) {
        price = newPrice
    }
}

protocol MenuViewCellDelegate: AnyObject {
    func didPressCell(collectionViewIndex: Int, cellIndex: Int, cellData: CellData)
}

class MenuView: UIView {
    private var buttonsView = ButtonsView()
    private var stackView = UIStackView()
    private var scrollView = UIScrollView()
    private var collectionViews: [UICollectionView] = []
    private var buttons: [UIButton] = []
    private var cellsData: [[CellData]] = [[]]
    weak var cellDelegate: MenuViewCellDelegate?
    
    // コードでビューを初期化するためのイニシャライザ
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    // Interface Builder (StoryboardやXIB)からビューを初期化するためのイニシャライザ
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        // View設定
        let cornerRadius: CGFloat = 20.0
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        self.backgroundColor = .systemCyan
        
        // ButtonsViewを追加する
        buttonsView.layer.cornerRadius = 20.0
        buttonsView.layer.masksToBounds = true
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonsView)
        // ButtonsViewの制約（Auto Layout）
        NSLayoutConstraint.activate([
            buttonsView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            buttonsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            buttonsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            buttonsView.widthAnchor.constraint(equalToConstant: 220)
        ])
        
        setupButtonsView()
    }
    
    func setupCellData(collectionViewNumber: Int, imageName: String, title: String, price: Int) {
        cellsData[collectionViewNumber].append(CellData(image: UIImage(named: imageName) ?? UIImage(), title: title, price: price))
    }
    
    private func setupButtonsView() {
        // UIScrollViewの作成
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        buttonsView.addSubview(scrollView)
        
        // UIScrollViewの制約設定
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: buttonsView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor)
        ])
        
        // StackViewのプロパティ設定
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        // StackViewをViewに追加
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        // 　　　　　　注意
        // 先にaddSubView、その後制約を設定する
        // でなければ、エラーが起きちゃう
        // stackViewの制約ではbuttonsViewに対して設定しないといけないだからだ
        
        // StackViewの中央配置
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        scrollView.contentSize = stackView.frame.size
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView.register(
            MenuCollectionViewCell.self,
            forCellWithReuseIdentifier: MenuCollectionViewCell.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.layer.cornerRadius = 20.0
        collectionView.layer.masksToBounds = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemOrange
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            collectionView.widthAnchor.constraint(equalToConstant: bounds.width - 250)
        ])
        
        collectionViews.append(collectionView)
        if collectionViews.count > 1 {
            collectionView.isHidden = true
        }
        cellsData.append([])
    }
    
    func insertButton(buttonTitle: String) {
        let button = createButton(title: buttonTitle)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25) // Set the desired font size
        stackView.addArrangedSubview(button)
        setupCollectionView()
    }
    
    private func createButton(title: String) -> UIButton{
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20.0
        button.layer.masksToBounds = true
        // Buttonのサイズ設定
        button.translatesAutoresizingMaskIntoConstraints = false
        buttons.append(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 70),
        ])
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc func buttonTapped( _ sender: UIButton) {
        for index in 0..<buttons.count {
            collectionViews[index].isHidden = buttons[index] != sender ? true : false
        }
    }
}

extension MenuView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        for index in 0..<collectionViews.count {
            if collectionViews[index] == collectionView {
                return cellsData[index].count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.identifier, for: indexPath) as? MenuCollectionViewCell else {
            fatalError("Failed to dequeue MenuCollectionViewCell.")
        }
        for index in 0..<collectionViews.count {
            if collectionView == collectionViews[index] {
                let cellData = cellsData[index][indexPath.row]
                cell.configure(with: cellData.image, title: cellData.title, number: cellData.price)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath) is MenuCollectionViewCell {
            for index in 0..<collectionViews.count {
                if collectionView == collectionViews[index] {
                    cellDelegate?.didPressCell(
                        collectionViewIndex: index,
                        cellIndex: indexPath.row,
                        cellData: cellsData[index][indexPath.row]
                    )
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (collectionView.frame.width - 40) / 3,
            height: (collectionView.frame.width - 40) / 3
        )
    }
}
