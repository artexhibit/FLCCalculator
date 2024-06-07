import UIKit

class FLCMenuButton: UIButton {
    
    private let padding: CGFloat = 17

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    override func menuAttachmentPoint(for configuration: UIContextMenuConfiguration) -> CGPoint {
        CGPoint(x: self.bounds.maxX - padding, y: self.bounds.minY - (padding / 2))
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
