//
//  LocalStorage.swift
//  Diary of feelings - drop your feelings according to the cloud village
//
//  Created by dan phi on 24/05/2023.
//

import Foundation
protocol LocalStorageType {
    func get<T>(key: LocalStorage.Keys) -> T?
    func save<T>(value: T?, key: LocalStorage.Keys,
                 async: Bool)
    func remove(key: LocalStorage.Keys, async: Bool)
    func getObject<T: Codable>(key: LocalStorage.Keys) -> T?
    func saveObject<T: Codable>(_ object: T, key: LocalStorage.Keys,
                                async: Bool)
    func clearAllData(async: Bool)
}

final class LocalStorage: LocalStorageType {
    enum Keys: String, RawRepresentable, Equatable, CaseIterable {
        case token
        case userAlreadyLookedUp
        case watchVideoCount
        case isAlreadyAskedRateApp
        case userProfile
        case usedTranslateCount
        case appConfig
        case expiredDate
        case practiceVocabulariesCount
        case showReadComicGuideFlag
        case isAskedForRateApp
        case readVolumeCount
    }

    private let storage: UserDefaults
    private let queueLabel = "LocalStorage"
    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()

    static var standard: LocalStorage {
        return LocalStorage(storage: UserDefaults.standard)
    }

    init(storage: UserDefaults) {
        self.storage = storage
    }

    /// Get value from local storage
    ///
    /// - Parameters:
    ///   - key: Unique key for each value.
    ///
    /// - Returns:
    /// Return nil if key not found, otherwise return value.
    func get<T>(key: Keys) -> T? {
        return storage.object(forKey: key.rawValue) as? T
    }

    /// Save value to local storage
    ///
    /// - Parameters:
    ///   - value: Value need to be saved.
    ///   - key: Unique key for each value.
    ///   - async: Default value is false.
    func save<T>(value: T?, key: Keys,
                 async: Bool) {
        if async {
            let queue = DispatchQueue(label: queueLabel)
            queue.async { [weak self] in
                self?.storage.set(value, forKey: key.rawValue)
            }
        } else {
            storage.set(value, forKey: key.rawValue)
        }
    }

    /// Remove key from local storage
    ///
    /// - Parameters:
    ///   - key: Unique key for each value.
    ///   - async: Default value is false.
    func remove(key: Keys, async: Bool) {
        if async {
            let queue = DispatchQueue(label: queueLabel)
            queue.async { [weak self] in
                self?.storage.removeObject(forKey: key.rawValue)
            }
        } else {
            storage.removeObject(forKey: key.rawValue)
        }
    }

    /// Get codable object from local storage
    ///
    /// - Parameters:
    ///   - key: Unique key for each value.
    ///
    /// - Returns:
    /// Return nil if key not found, otherwise return object.
    func getObject<T: Codable>(key: Keys) -> T? {
        if let jsonData: Data = get(key: key) {
            return try? jsonDecoder.decode(T.self, from: jsonData)
        }
        return nil
    }

    /// Save object to local storage
    ///
    /// - Parameters:
    ///   - object: Value need to be saved.
    ///   - key: Unique key for each value.
    ///   - async: Default value is false.
    ///
    /// - Returns:
    /// Return true if save successfully, otherwise return false.
    func saveObject<T: Codable>(_ object: T, key: Keys,
                                async: Bool) {
        if let jsonData = try? jsonEncoder.encode(object) {
            save(value: jsonData, key: key, async: async)
        }
    }

    /// Clear all data in both storage and secure storage
    ///
    /// - Parameters:
    ///   - async: Default value is false.
    func clearAllData(async: Bool = false) {
        clearStorage(async: async)
    }

    private func clearStorage(async: Bool) {
        for key in Keys.allCases {
            remove(key: key, async: async)
        }
    }
}
