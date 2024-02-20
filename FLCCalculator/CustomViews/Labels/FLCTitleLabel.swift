import UIKit

class FLCTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor, textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        self.textColor = color
        self.textAlignment = textAlignment
    }
    
    private func configure() {
        font = UIFont.systemFont(ofSize: 25, weight: .bold)
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.7
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
