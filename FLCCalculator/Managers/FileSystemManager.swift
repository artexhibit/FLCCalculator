import Foundation

struct FileSystemManager {
    static func getLocalFileURL(for fileName: String) -> URL? {
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return docDirectory.appendingPathComponent(fileName)
    }
}
