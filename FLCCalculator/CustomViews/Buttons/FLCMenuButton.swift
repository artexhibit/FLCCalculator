import UIKit

class FLCMenuButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() { translatesAutoresizingMaskIntoConstraints = false }
    
    func configureMenu(with menu: UIMenu) {
        self.menu = menu
        showsMenuAsPrimaryAction = true
    }
}
