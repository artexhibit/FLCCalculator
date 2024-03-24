import Foundation

struct PersistenceManager {
    private static let ud = UserDefaults.sharedContainer
    
    static func update(tariffs: [Tariff], completed: @escaping (Result<[Tariff], FLCError>) -> Void) {
        retrieveTariffs { result in
            switch result {
            case .success(let storedTariffs):
                ud.removeObject(forKey: Keys.tariffs)
                
                if let savingError = save(tariffs: tariffs) {
                    let _ = save(tariffs: storedTariffs)
                    completed(.failure(savingError))
                } else {
                    completed(.success([]))
                }
            case .failure(_):
                if let savingError = save(tariffs: tariffs) {
                    completed(.failure(savingError))
                } else {
                    completed(.success([]))
                }
            }
        }
    }
    
    static func retrieveTariffs(completed: @escaping (Result<[Tariff], FLCError>) -> Void) {
        guard let tariffsData = ud.object(forKey: Keys.tariffs) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let tariffs = try decoder.decode([Tariff].self, from: tariffsData)
            completed(.success(tariffs))
        } catch {
            completed(.failure(.unableToRetrieveTariffs))
        }
    }
    
    private static func save(tariffs: [Tariff]) -> FLCError? {
        do {
            let encoder = JSONEncoder()
            let encodedTariffs = try encoder.encode(tariffs)
            ud.setValue(encodedTariffs, forKey: Keys.tariffs)
            return nil
        } catch  {
            return .unableToSaveTariffs
        }
    }
}
