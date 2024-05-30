import UIKit

struct AuthorizationVCHelper {
    static func showPrivacyPolicy(in vc: UIViewController) {
        let privacyPolicyDoc = Document(title: "", fileName: "documents/personalDataProcessingRules.pdf", docDate: "")
        
        if FileSystemManager.isHavingDocument(with: privacyPolicyDoc.fileName) {
            guard let url = FileSystemManager.getLocalFileURL(for: privacyPolicyDoc.fileName) else { return }
            FileSystemManager.openDocument(with: url, in: vc)
        } else {
            FLCPopupView.showOnMainThread(title: "Загружаю файл", style: .spinner)
            FirebaseManager.downloadDocument(doc: privacyPolicyDoc) { result in
                guard let progress = result.progress, let url = result.url else { return }
                
                if progress == 100 {
                    HapticManager.addSuccessHaptic()
                    FileSystemManager.openDocument(with: url, in: vc)
                }
                
            }
        }
        FLCPopupView.removeFromMainThread()
    }
}
