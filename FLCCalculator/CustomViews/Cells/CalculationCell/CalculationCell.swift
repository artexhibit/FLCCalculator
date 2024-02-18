import UIKit
import SwiftUI

class CalculationCell: UITableViewCell {
    static let reuseID = "CalculationCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        animateCell(when: highlighted)
    }
    
    func set(calculation: Calculation) {
        contentConfiguration = UIHostingConfiguration(content: {
            CalculationView(calculation: calculation)
        })
    }
    
    private func configure() {
        self.selectionStyle = .none
    }
    
    private func animateCell(when highlighted: Bool) {
        let transform = highlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : CGAffineTransform.identity
        UIView.animate(withDuration: 0.2) { self.transform = transform }
    }
}
