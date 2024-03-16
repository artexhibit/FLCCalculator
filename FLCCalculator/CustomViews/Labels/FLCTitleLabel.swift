import UIKit

class FLCTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor, textAlignment: NSTextAlignment, size: CGFloat = 24) {
        self.init(frame: .zero)
        self.textColor = color
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    private func configure() {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.7
        numberOfLines = 0
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
