import UIKit

class FLCSubtitleLabel: UILabel {
    
    private var shimmeringView = FLCShimmeringView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addShimmeringView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor, textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        self.textColor = color
        self.textAlignment = textAlignment
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shimmeringView.frame = self.bounds
    }
    
    private func configure() {
        font = UIFont.preferredFont(forTextStyle: .callout)
        minimumScaleFactor = 0.9
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addShimmeringView() {
        shimmeringView = FLCShimmeringView(frame: self.bounds)
        addSubview(shimmeringView)
    }
    
    func addShimmerAnimation() { shimmeringView.addShimmerAnimation() }
    func removeShimmerAnimation() { shimmeringView.removeShimmerAnimation() }
}
