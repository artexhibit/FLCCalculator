import UIKit

protocol FLCRoundButtonDelegate: AnyObject {
    func didTapButton(_ button: FLCRoundButton)
}

class FLCRoundButton: UIButton {
    
    private var shimmeringView = FLCShimmeringView()
    private let imageSizeConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .default)
    
    weak var delegate: FLCRoundButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(image: UIImage, tint: UIColor, cornerStyle: UIButton.Configuration.CornerStyle = .small, title: String? = nil) {
        self.init(frame: .zero)
        configuration?.cornerStyle = cornerStyle
        configuration?.image = image
        configuration?.baseBackgroundColor = tint
        configuration?.baseForegroundColor = tint
        if title != nil { configuration?.title = title }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shimmeringView.frame = self.bounds
    }
    
    private func configure(size: Double = 0) {
        configuration = .tinted()
        configuration?.imagePlacement = .top
        configuration?.imagePadding = 5
        configuration?.preferredSymbolConfigurationForImage = imageSizeConfig
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
        configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 10)
            return outgoing
        }
        
        tintAdjustmentMode = .normal
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func addShimmeringView() {
        shimmeringView = FLCShimmeringView(frame: self.bounds, insets: (0,0))
        addSubview(shimmeringView)
        bringSubviewToFront(shimmeringView)
    }
    
    func addShimmerAnimation() {
        addShimmeringView()
        shimmeringView.addShimmerAnimation()
    }
    
    func removeShimmerAnimation() {
        shimmeringView.removeShimmerAnimation()
        shimmeringView.removeFromSuperview()
    }
    
    @objc private func buttonTapped() {
        HapticManager.addHaptic(style: .light)
        delegate?.didTapButton(self)
    }
}
