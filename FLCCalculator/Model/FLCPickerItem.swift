import UIKit

struct FLCPickerItem: Hashable {
    let title: String
    let subtitle: String
    let image: UIImage?
    let id: String
    
    init(title: String, subtitle: String, image: UIImage?, id: String = "1") {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.id = id
    }
}
