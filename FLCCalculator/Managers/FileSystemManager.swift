import UIKit

struct FileSystemManager {
    static func getLocalFileURL(for fileName: String) -> URL? {
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return docDirectory.appendingPathComponent(fileName)
    }
    
    static func openDocument(with url: URL, in vc: UIViewController) {
        let docInteractionController = UIDocumentInteractionController(url: url)
        docInteractionController.delegate = vc as? UIDocumentInteractionControllerDelegate
        DispatchQueue.main.async { docInteractionController.presentPreview(animated: true) }
    }
    
    static func isHavingDocument(with fileName: String) -> Bool {
        guard let url = getLocalFileURL(for: fileName) else { return false }
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    static func deleteDocument(with fileName: String) {
        guard let url = getLocalFileURL(for: fileName) else { return }
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print(FLCError.errorDeletingFile)
        }
    }
}
