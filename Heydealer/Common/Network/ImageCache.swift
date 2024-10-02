//
//  ImageCache.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//

import Foundation
import UIKit

@MainActor
struct ImageCache {
    
    private static let cacheTimeKey   = "image_cache_time"
    private static let cacheLifeCycle = 1
    
    static func clear() {
        clearCacheTime()
        clearCacheDirectory()
    }
    
    static func cache(_ data: Data, for url: URL) {
        guard let cacheUrl = confirmCacheDirectory() else { return }
        
        guard let fileName = fileName(about: url) else { return }
        
        do {
            try data.write(to: cacheUrl.appendingPathComponent(fileName))
            
            saveCacheTimeIfNeeded()
        } catch {
            assert(false, error.localizedDescription)
        }
    }
    
    static func getImageData(for url: URL) -> Data? {
        guard isValidLifeCycle() else {
            clear()
            return nil
        }
        
        guard let cacheUrl = confirmCacheDirectory(), let fileName = fileName(about: url) else { return nil }
        
        let fileUrl = cacheUrl.appendingPathComponent(fileName)
        
        guard FileManager.default.fileExists(atPath: fileUrl.path) else { return nil }
        
        do {
            let imageData = try Data(contentsOf: fileUrl)
            
            return imageData
        } catch {
            assert(false, error.localizedDescription)
            return nil
        }
    }
    
}

// MARK: file path manage
private extension ImageCache {
    
    static func clearCacheDirectory() {
        guard let url = confirmCacheDirectory(with: false) else { return }
        
        do {
            try FileManager.default.removeItem(atPath: url.path)
        } catch {
            assert(false, error.localizedDescription)
        }
    }
    
    static func confirmCacheDirectory(with create: Bool = true) -> URL? {
        guard let url = try? FileManager.default.imageCachesDirectory() else {
            assert(false)
            return nil
        }
        
        guard !FileManager.default.fileExists(atPath: url.path) else { return url }
        guard create else { return nil }
        
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            
            return url
        } catch {
            assert(false)
            return nil
        }
    }
    
    static func fileName(about url: URL) -> String? {
        guard let name = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .init()) else {
            assert(false)
            return nil
        }
        
        return name
    }
    
}

// MARK: cache life cycle
private extension ImageCache {
    
    static func isValidLifeCycle() -> Bool {
        guard let time = cacheTime(), let validTime = time.addDay(1) else { return true }
        guard validTime.timeIntervalSinceNow < 0 else { return true }
        
        return false
    }
    
    static func saveCacheTimeIfNeeded() {
        guard cacheTime() == nil else { return }
        
        UserDefaults.standard.set(Date(), forKey: cacheTimeKey)
    }
    
    static func cacheTime() -> Date? {
        UserDefaults.standard.object(forKey: cacheTimeKey) as? Date
    }
    
    static func clearCacheTime() {
        UserDefaults.standard.removeObject(forKey: cacheTimeKey)
    }
    
}

// MARK: FileManager
private extension FileManager {
    enum DirectoryError: Error {
        case notFound
    }
    func imageCachesDirectory() throws -> URL {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { throw DirectoryError.notFound }
        
        return path.appendingPathComponent("image_caches")
    }
}
