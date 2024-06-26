import UIKit

protocol FLCCalculationViewDelegate: AnyObject {
    func didEnterRequiredInfo()
    func didTapListPickerButton(_ button: FLCListPickerButton)
    func didTapFLCButton(_ button: FLCButton)
    func didTapFLCTextButton(_ button: FLCTextButton)
    func didSelectItem(pickedItem: FLCPickerItem, triggerButton button: FLCListPickerButton)
}

class FLCCalculationView: UIView {
    
    let padding: CGFloat = 15
    let titleLabel = FLCTitleLabel(color: .label, textAlignment: .left)
    var flcTextFields = [FLCNumberTextField]()
    var flcListPickerButtons = [FLCListPickerButton]()
    
    weak var delegate: FLCCalculationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
    }
    
    private func configureTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding * 2),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])
    }
}

extension FLCCalculationView: FLCListPickerButtonDelegate {
    func didTapButton(_ button: FLCListPickerButton) { delegate?.didTapListPickerButton(button) }
}

extension FLCCargoParametersView: FLCButtonDelegate {
    func didTapButton(_ button: FLCButton) {
        if self.showingPopover.isShowing { self.showingPopover.hidePopoverFromMainThread() }
        delegate?.didTapFLCButton(button)
    }
}

extension FLCTransportParametersView: FLCButtonDelegate {
    func didTapButton(_ button: FLCButton) { delegate?.didTapFLCButton(button) }
}

extension FLCTransportParametersView: FLCTextButtonDelegate {
    func didTapButton(_ button: FLCTextButton) { delegate?.didTapFLCTextButton(button) }
}

extension FLCCargoParametersView: CalculationVCDelegate {
    func closeButtonPressed() { if self.showingPopover.isShowing { self.showingPopover.hidePopoverFromMainThread() } }
    func scrollViewDidScroll() { if self.showingPopover.isShowing { self.showingPopover.hidePopoverFromMainThread() } }
}
