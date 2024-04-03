import UIKit

class FLCPopoverVC: UIViewController {
    
    private let closeButton = UIButton()
    private let textLabel = FLCSubtitleLabel(color: .label.withAlphaComponent(0.7), textAlignment: .left)
    
    private let padding: CGFloat = 15
    private var closeButtonTopConstraint: NSLayoutConstraint!
    private var textLabelBottomConstraint: NSLayoutConstraint!
    
    var isShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureCloseButton()
        configureTextLabel()
    }
    
    private func configure() {
        view.backgroundColor = .darkGray.withAlphaComponent(0.1)
        modalPresentationStyle = .popover
        view.addSubviews(closeButton, textLabel)
    }
    
    func showPopoverOnMainThread(withText: String, in viewController: UIViewController, target: UIView, characterRange: NSRange? = nil, presentedVC: UIViewController? = nil) {
        DispatchQueue.main.async {
            self.isShowing = true
            self.textLabel.text = withText
            self.preferredContentSize = self.setupPreferredContentSize(in: viewController)
            
            let position = self.setTipPosition(in: viewController.view, target: target, popoverHeight: self.preferredContentSize.height)
            
            self.configurePresentationVC(with: position, target: target, vc: viewController, characterRange: characterRange)
            
            presentedVC == nil ? viewController.present(self, animated: true) : presentedVC?.present(self, animated: true)
        }
    }
    
    private func configureCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        closeButton.setImage(Icons.xmark, for: .normal)
        closeButton.tintColor = .gray
        closeButton.contentVerticalAlignment = .fill
        closeButton.contentHorizontalAlignment = .fill
        closeButton.imageView?.contentMode = .scaleAspectFit
        
        closeButtonTopConstraint = closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: padding / 1.5)
        
        closeButton.addTarget(self, action: #selector(hidePopoverFromMainThread), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeButtonTopConstraint,
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding / 1.5),
            closeButton.widthAnchor.constraint(equalToConstant: 18),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor)
        ])
    }
    
    private func configureTextLabel() {
        textLabelBottomConstraint = textLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding * 1.5)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: padding / 2),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            textLabelBottomConstraint
        ])
    }
    
    private func setTipPosition(in view: UIView, target: UIView, popoverHeight: CGFloat) -> FLCPopoverPosition {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        let activeWindow = view.window?.windowScene?.windows.first { $0.isKeyWindow }
        let targetFrameInWindow = target.convert(target.bounds, to: activeWindow)
        let safeAreaVerticalInsets = (activeWindow?.safeAreaInsets.bottom ?? 0) + (activeWindow?.safeAreaInsets.top ?? 0)
        let spaceBelowTarget = (activeWindow?.frame.maxY ?? 0) - targetFrameInWindow.maxY - safeAreaVerticalInsets
        return popoverHeight > spaceBelowTarget ? .top : .bottom
    }
    
    private func configurePresentationVC(with position: FLCPopoverPosition, target: UIView, vc: UIViewController, characterRange: NSRange? = nil) {
        var sourceRectY: CGFloat = 0
        var iconPosition: (x: CGFloat, y: CGFloat) = (0, 0)
        
        if let textView = target as? UITextView { iconPosition = textView.getIconAttachmentPosition(for: characterRange ?? NSRange()) }
        
        guard let presentationVC = self.popoverPresentationController else { return }
        
        switch position {
        case .top:
            presentationVC.permittedArrowDirections = .down
            self.closeButtonTopConstraint.constant = self.padding / 1.5
            self.textLabelBottomConstraint.constant = -self.padding * 1.5
            sourceRectY = iconPosition.y - 15
        case .bottom:
            presentationVC.permittedArrowDirections = .up
            self.closeButtonTopConstraint.constant = self.padding * 1.7
            self.textLabelBottomConstraint.constant = -self.padding / 1.3
            sourceRectY = iconPosition.y + 15
        }
        presentationVC.backgroundColor = .clear
        presentationVC.sourceView = target
        presentationVC.passthroughViews = [vc.view]
        presentationVC.delegate = vc as? UIPopoverPresentationControllerDelegate
        presentationVC.sourceRect = CGRect(x: iconPosition.x, y: sourceRectY, width: 0, height: 0)
    }
    
    private func setupPreferredContentSize(in vc: UIViewController) -> CGSize {
        self.view.layoutIfNeeded()
        let targetSize = CGSize(width: vc.view.bounds.width * 0.9, height: UIView.layoutFittingCompressedSize.height)
        let contentSize = self.view.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)

        return contentSize
    }
    
    @objc func hidePopoverFromMainThread() {
        DispatchQueue.main.async {
            HapticManager.addHaptic(style: .light)
            self.isShowing = false
            self.dismiss(animated: true)
        }
    }
}
