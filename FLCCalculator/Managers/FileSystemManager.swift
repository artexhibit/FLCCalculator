import UIKit

struct FileSystemManager {
    static func getLocalFileURL(for fileName: String) -> URL? {
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return docDirectory.appendingPathComponent(fileName)
    }
    
    static func openDocument(with url: URL, in view: UIView) {
        let docInteractionController = UIDocumentInteractionController(url: url)
        docInteractionController.delegate = view as? UIDocumentInteractionControllerDelegate
        DispatchQueue.main.async { docInteractionController.presentPreview(animated: true) }
    }
}
