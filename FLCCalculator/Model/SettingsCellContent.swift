import UIKit

struct SettingsSection {
    let title: String
    let sectionFooter: String
    let items: [SettingsCellContent]
}

struct SettingsCellContent {
    let cellType: FLCSettingsCellType
    let contentType: FLCSettingsContentType
    let image: UIImage?
    let backgroundColor: UIColor? = .flcGraySingle
    let title: String
    let subtitle: String?
    let pickedOption: String?
}
