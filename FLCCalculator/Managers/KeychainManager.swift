import Foundation

class KeychainManager {
    static let shared = KeychainManager()
    
    func save<T: KeychainStorable>(_ item: T) {
        
        do {
            let data = try JSONEncoder().encode(item)
            save(data, service: T.serviceKey, account: T.accountKey)
        } catch {
            print(FLCError.unableToEncodeFromKeychain.rawValue)
        }
    }
    
    func read<T: KeychainStorable>(type: T.Type) -> T? {
        guard let data = read(service: T.serviceKey, account: T.accountKey) else { return nil }
        
        do {
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch {
            print(FLCError.unableToDecodeFromKeychain.rawValue)
            return nil
        }
    }
    
    private func save(_ data: Data, service: String, account: String) {
        let query = [
            kSecValueData: data,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status == errSecDuplicateItem {
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            SecItemUpdate(query, attributesToUpdate)
        }
    }
    
    private func read(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    func delete<T: KeychainStorable>(type: T.Type) {
        let query = [
            kSecAttrService: T.serviceKey,
            kSecAttrAccount: T.accountKey,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary
        
        SecItemDelete(query)
    }
}
