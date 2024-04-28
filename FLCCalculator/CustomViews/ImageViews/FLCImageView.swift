import UIKit

class FLCImageView: UIImageView {
    
    private var shimmeringView = FLCShimmeringView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addShimmeringView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(mode: UIView.ContentMode = .scaleAspectFit, image: UIImage? = nil, tint: UIColor? = nil) {
        self.init(frame: .zero)
        self.contentMode = mode
        self.image = image
        self.tintColor = tint
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shimmeringView.frame = self.bounds
    }
    
    private func configure() { translatesAutoresizingMaskIntoConstraints = false }
    
    private func addShimmeringView() {
        shimmeringView = FLCShimmeringView(frame: self.bounds)
        addSubview(shimmeringView)
    }
    
    func addShimmerAnimation() { shimmeringView.addShimmerAnimation() }
    func removeShimmerAnimation() { shimmeringView.removeShimmerAnimation() }
}
