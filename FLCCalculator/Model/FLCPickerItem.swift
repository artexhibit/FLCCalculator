import UIKit

struct FLCPickerItem: Hashable {
    let title: String
    let subtitle: String
    let image: UIImage?
    let id: String
    let canBeAddedAsTitle: Bool
    let shouldDisplayOnTop: Bool
    
    init(title: String, subtitle: String, image: UIImage?, id: String = "1", isOpenForAdd: Bool = true, shouldDisplayOnTop: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.id = id
        self.canBeAddedAsTitle = isOpenForAdd
        self.shouldDisplayOnTop = shouldDisplayOnTop
    }
}
