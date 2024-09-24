import UIKit

struct SettingsSection {
    let title: String
    let sectionFooter: String
    let items: [SettingsCellContent]
    
    init(title: String = "", sectionFooter: String = "", items: [SettingsCellContent]) {
        self.title = title
        self.sectionFooter = sectionFooter
        self.items = items
    }
}

struct SettingsCellContent {
    let cellType: FLCSettingsCellType
    let contentType: FLCSettingsContentType
    let image: UIImage?
    let backgroundColor: UIColor?
    let title: String
    let subtitle: String?
    let pickedOption: String?
    let switchState: Bool?
    
    init(cellType: FLCSettingsCellType, contentType: FLCSettingsContentType, image: UIImage? = nil, backgroundColor: UIColor? = .flcGraySingle, title: String, subtitle: String? = nil, pickedOption: String? = nil, switchState: Bool? = nil) {
        self.cellType = cellType
        self.contentType = contentType
        self.image = image
        self.backgroundColor = backgroundColor
        self.title = title
        self.subtitle = subtitle
        self.pickedOption = pickedOption
        self.switchState = switchState
    }
}
