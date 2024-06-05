import UIKit

struct SettingsSection {
    let title: String
    let items: [SettingsCellContent]
}

struct SettingsCellContent {
    let cellType: FLCSettingsCellType
    let contentType: FLCSettingsContentType
    let image: UIImage?
    let backgroundColor: UIColor? = .flcGray
    let title: String
    let subtitle: String?
    let pickedOption: String?
}
