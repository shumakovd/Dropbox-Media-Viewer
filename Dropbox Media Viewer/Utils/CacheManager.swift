//
//  CacheManager.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 29.08.2023.
//

import Kingfisher
import Foundation

// The cache manager works in connection with the cache observer.
// Each time the model is updated, the public variable in the AppConfiguration file will be updated.

// MARK: - Cache Keys

enum CacheKey: String, CaseIterable {
    case user, accessToken
}

// MARK: - Cache Observer

protocol CacheObserver: AnyObject {
    func cacheDidUpdate(key: CacheKey)
}

class MyCacheObserver: CacheObserver {
   
    var cachedUser: UserML? {
        didSet {
            // Update public user model
            AppConfiguration.userModel = cachedUser
            print("◊ Cache (USER): \(String(describing: cachedUser)))")
        }
    }
    
    var accessToken: String? {
        didSet {
            // Update public access token
            AppConfiguration.accessToken = accessToken
            print("◊ Cache (Access Token): \(String(describing: accessToken)))")
        }
    }
    
    func cacheDidUpdate(key: CacheKey) {
        // Update public variable with the new cached value
        switch key {
        case .user:
            cachedUser = CacheManager.shared.get(key: .user, type: UserML.self)
            
        case .accessToken:
            accessToken = CacheManager.shared.get(key: .accessToken, type: String.self)

        default:
            break
        }
    }
}

// MARK: - Cache Manager

/// How to use
/// Create an observer and add it to the cache manager
/// let observer = MyCacheObserver()
/// CacheManager.shared.addObserver(observer)

/// Get value from the cache
/// CacheManager.shared.get(key: .user, type: UserML.self)

/// Store a value in the cache
/// let person = UserML(name: "John", age: 30)
/// CacheManager.shared.set(key: .user, value: person)

/// Update the cached value by updating the age field
/// CacheManager.shared.update(key: .user) { person in
///    person.age += 1
/// }

class CacheManager {
    
    // MARK: - Properties
        
    private let cache = NSCache<NSString, NSData>()
    private var observers = [CacheObserver]()
    private let userDefaults = UserDefaults.standard
            
    private let cacheKey = "com.dropbox-media-viewer.cache"
    
    static let shared = CacheManager()
    private init() {}
    
    // MARK: - Public Methods
    
    func get<T: Codable>(key: CacheKey, type: T.Type) -> T? {
        // guard let data = cache.object(forKey: key.rawValue as NSString) else { return nil }
        guard let data = userDefaults.data(forKey: key.rawValue) else { return nil }
        
        let decoder = JSONDecoder()
        do {
            let value = try decoder.decode(type, from: data as Data)
            return value
        } catch {
            print("Error decoding value for key \(key): \(error.localizedDescription)")
            return nil
        }
    }
            
    func set<T: Codable>(key: CacheKey, value: T?) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(value)
            cache.setObject(data as NSData, forKey: key.rawValue as NSString)
            userDefaults.set(data, forKey: key.rawValue)
            notifyObservers(key: key)
        } catch {
            print("Error encoding value for key \(key): \(error.localizedDescription)")
        }
    }
     
    func removeData(forKey key: CacheKey) {
        userDefaults.removeObject(forKey: key.rawValue)
        notifyObservers(key: key)
    }
    
    func removeAllData() {
        if let domain = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: domain)
        }
        
        for each in CacheKey.allCases {
            notifyObservers(key: each)
        }
    }
    
    // MARK: - Observer Methods
    
    func addObserver(_ observer: CacheObserver) {
        observers.append(observer)
    }
    
    func removeObserver(_ observer: CacheObserver) {
        if let index = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }
    
    private func notifyObservers(key: CacheKey) {
        for observer in observers {
            observer.cacheDidUpdate(key: key)
        }
    }
}

// MARK: - Image Cache

class ImageCache {
    static let shared = ImageCache()
    
    private var cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func removeImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func removeAllImages() {
        cache.removeAllObjects()
    }
}
