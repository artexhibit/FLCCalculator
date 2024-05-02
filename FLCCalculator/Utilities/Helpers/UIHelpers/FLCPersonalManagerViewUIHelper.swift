import UIKit

struct FLCPersonalManagerViewUIHelper {
    static func createPhoneCall(with number: String) {
        var finalNumber = "tel://\(number)"
        
        if number.contains("доб") {
            let extNumber = number.getLastCharacters(3)
            let pauseCharacter = ","
            finalNumber = finalNumber.removeLastCharacters(3)
            finalNumber += pauseCharacter + extNumber
        }
        
        if let url = URL(string: finalNumber) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось совершить звонок")
        }
    }
    
    static func goToTelegram(of manager: FLCManager?) {
        guard let appURL = URL(string: "tg://resolve?domain=\(manager?.telegram ?? "")") else {
            FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось найти никнейм в Telegram", style: .error)
            return
        }
        guard let webURL = URL(string: "https://t.me/\(manager?.telegram ?? "")") else {
            FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось найти никнейм в Telegram", style: .error)
            return
        }
        
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
    
    static func goToWhatsapp(of manager: FLCManager?) {
        guard let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(manager?.whatsapp.extractDigits() ?? "")") else {
            FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось найти никнейм в Whatsapp", style: .error)
            return
        }
        guard let webURL = URL(string: "https://wa.me/\(manager?.whatsapp.extractDigits() ?? "")") else {
            FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось найти никнейм в Whatsapp", style: .error)
            return
        }
        
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
    
    static func sendEmail(from view: UIView, manager: FLCManager?) {
        guard let parentVC = view.findParentViewController() else { return }
        let subject = "Подтверждение заявки на импортную перевозку груза"
        let message = "\(manager?.name.getDataBetweenCharacter() ?? ""), добрый день, \nГотов подтвердить заявку. \nИнформация в прикреплённом файле"
        FLCMailComposeVC.sendEmailTo(email: manager?.email ?? "", subject: subject, message: message, from: parentVC)
    }
    
    static func showPhoneCallUIMenu(of manager: FLCManager?) -> UIMenu {
        let mobileNumberItem = UIAction(title: manager?.mobilePhone ?? "", subtitle: "Мобильный", image: Icons.phone) { (_) in
            createPhoneCall(with: manager?.mobilePhone ?? "")
        }
        let landlineNumberItem = UIAction(title: manager?.landlinePhone ?? "", subtitle: "Стационарный", image: Icons.phone) { (_) in
            createPhoneCall(with: manager?.landlinePhone ?? "")
        }
        return UIMenu(title: "Контактные номера телефонов", children: [mobileNumberItem, landlineNumberItem])
    }
    
    static func configurePhoneButtonMenu(phoneButton: FLCRoundButton, of manager: FLCManager) {
        phoneButton.menu = showPhoneCallUIMenu(of: manager)
        phoneButton.showsMenuAsPrimaryAction = true
    }
    
    static func configureItemsContent(manager: FLCManager, avatarView: FLCImageView, nameLabel: FLCTitleLabel, contactsLabel: FLCSubtitleLabel) {
        avatarView.image = manager.avatar ?? CalculationInfo.defaultManager.avatar
        nameLabel.text = manager.name
        contactsLabel.text = "\(manager.email) \n\(manager.landlinePhone)"
    }
    
    static func addShimmerAnimationToItems(avatarView: FLCImageView, nameLabel: FLCTitleLabel, contactsLabel: FLCSubtitleLabel, roundButtons: [FLCRoundButton]) {
        avatarView.addShimmerAnimation()
        nameLabel.addShimmerAnimation()
        contactsLabel.addShimmerAnimation()
        roundButtons.forEach {
            $0.addShimmerAnimation()
            $0.isUserInteractionEnabled = false
        }
    }
    
    static func removeShimmerAnimationFromItems(avatarView: FLCImageView, nameLabel: FLCTitleLabel, contactsLabel: FLCSubtitleLabel, roundButtons: [FLCRoundButton]) {
        avatarView.removeShimmerAnimation()
        avatarView.layer.borderColor = UIColor.lightGray.cgColor
        nameLabel.removeShimmerAnimation()
        contactsLabel.removeShimmerAnimation()
        
        roundButtons.forEach {
            $0.removeShimmerAnimation()
            $0.isUserInteractionEnabled = true
        }
    }
}
