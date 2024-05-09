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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateCell(whenTouchesBegan: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateCell(whenTouchesBegan: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateCell(whenTouchesBegan: false)
    }
    
    func set(calculation: Calculation) {
        contentConfiguration = UIHostingConfiguration(content: {
            CalculationView(calculation: calculation)
        })
    }
    
    private func configure() {
        self.selectionStyle = .none
    }
    
    private func animateCell(whenTouchesBegan: Bool) {
        let transform = whenTouchesBegan ? CGAffineTransform(scaleX: 0.95, y: 0.95) : CGAffineTransform.identity
        UIView.animate(withDuration: 0.2) { self.transform = transform }
    }
}
