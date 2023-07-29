import UIKit

class ButtonsView: UIView {
    private var buttons: [UIButton] = []
    private var stackView: UIStackView!

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
    }

    // ボタンを入れる
    func insertButton(button: UIButton) {
        buttons.append(button)
        stackView.addSubview(button)
    }

    // ボタンを削除する
    func deleteButton(button: UIButton) {
        if let buttonIndex = buttons.firstIndex(of: button) {
            buttons.remove(at: buttonIndex)
        }
    }
}
