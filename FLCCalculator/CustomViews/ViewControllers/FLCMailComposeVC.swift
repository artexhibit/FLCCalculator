import MessageUI

protocol FLCMailComposeDelegate: MFMailComposeViewControllerDelegate {
    func handleMailComposeResult(_ result: MFMailComposeResult)
}

extension FLCMailComposeDelegate where Self: UIViewController {
    func handleMailComposeResult(_ result: MFMailComposeResult) {
        switch result {
        case .cancelled, .saved, .failed, .sent:
            if result == .sent {
                FLCPopupView.showOnMainThread(systemImage: "checkmark", title: "Письмо отправлено")
            } else if result == .failed {
                FLCPopupView.showOnMainThread(systemImage: "xmark", title: "Не удалось отправить сообщение", style: .error)
            }
            dismiss(animated: true, completion: nil)
        @unknown default:
            dismiss(animated: true, completion: nil)
        }
    }
}

class FLCMailComposeVC: MFMailComposeViewController {
    
    init(recipient: String, subject: String, message: String, delegate: MFMailComposeViewControllerDelegate?) {
        super.init(nibName: nil, bundle: nil)
        
        setToRecipients([recipient])
        setSubject(subject)
        setMessageBody(message, isHTML: false)
        mailComposeDelegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func sendEmailTo(email: String, subject: String, message: String, from viewController: UIViewController) {
        let mailVC = FLCMailComposeVC(recipient: email, subject: subject, message: message, delegate: viewController as? MFMailComposeViewControllerDelegate)
        
        if MFMailComposeViewController.canSendMail() {
            viewController.present(mailVC, animated: true, completion: nil)
        } else {
            sendThroughMailto(toEmail: email, subject: subject, message: message)
        }
    }
    
    private static func sendThroughMailto(toEmail recipient: String, subject: String, message: String) {
        guard let emailString = "mailto:\(recipient)?subject=\(subject)&body=\(message)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let emailURL = URL(string: emailString) else { return }
        
        if UIApplication.shared.canOpenURL(emailURL) {
            UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
        }
    }
}
