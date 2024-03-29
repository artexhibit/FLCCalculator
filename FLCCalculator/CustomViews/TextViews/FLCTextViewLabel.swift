import UIKit

class FLCTextViewLabel: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var canBecomeFirstResponder: Bool { return false }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(select(_:)) { return false }
        return true
    }
    
    convenience init(text: NSAttributedString? = nil) {
        self.init(frame: .zero, textContainer: nil)
        self.attributedText = text
        configure()
    }
    
    func setStyle(color: UIColor, textAlignment: NSTextAlignment, fontWeight: UIFont.Weight = .regular, fontSize: CGFloat) {
        self.textColor = color
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        isScrollEnabled = false
        isEditable = false
        backgroundColor = .clear
    
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.maximumNumberOfLines = 0
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        adjustsFontForContentSizeCategory = true
        allowsEditingTextAttributes = false
    }
}
