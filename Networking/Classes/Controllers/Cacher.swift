//
//  CacheGetter.swift
//  MBNetworking
//
//  Created by Matt Beaney on 15/01/2018.
//

import Foundation
import CryptoSwift

public class Cacher : Cacheable {
    private var ttlManager: TTLManaging
    public init(ttlManager: TTLManaging) {
        self.ttlManager = ttlManager
    }
    
    public func cacheInDate(url: URL, type: String) -> Bool {
        if case DownloadResult.failure(error: _) = self.get(url: url, type: type) { return false }
        return ttlManager.cacheInDate(url: url, type: type)
    }
    
    /**
     Fetches data from the disk.
     - parameter url: The URL for which data needs to be fetched.
     - parameter type: A string representing the sub-cache folder that you want.
     */
    public func get(url: URL, type: String) -> DownloadResult {
        guard let cache = self.fetchCachePath(folder: type) else {
            return .failure(error: Errors.Caching.PATH_INVALID)
        }
        
        guard
            let cachedData = try? Data(contentsOf: self.fullPath(cache: cache, fileName: url.absoluteString.sha1())),
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            else
        {
            return .failure(error: Errors.Caching.NO_STORED_DATA)
        }
        
        return .success(data: cachedData, response: response)
    }
    
    /**
     Writes data to the disk.
     - parameter url: The URL for which data needs to be stored.
     - parameter data: The data representation of the contents of the URL.
     */
    public func set(url: URL, data: Data, secondsTTL: Int, type: String) {
        guard let cache = self.fetchCachePath(folder: type) else {
            return
        }
        
        self.ttlManager.setTTL(url: url, secondsTTL: secondsTTL, type: type)
        try? data.write(to: self.fullPath(cache: cache, fileName: url.absoluteString.sha1()), options: .atomic)
    }
    
    public func clearCache(type: String) {
        guard let cachePath = self.fetchCachePath(folder: type) else { return }
        try? FileManager.default.removeItem(at: cachePath)
        self.ttlManager.clearTTLs(type: type)
    }
    
    /**
     Fetches the full URL, given the URL and cache URL.
     - parameter cache: The URL for the caches folder
     - parameter url: The URL.
     - returns: The full URL path
     */
    fileprivate func fullPath(cache: URL, fileName: String) -> URL {
        return cache.appendingPathComponent("\(fileName).dat")
    }
    
    /**
     Fetches cache URL.
     - returns: The cache URL.
     */
    fileprivate func fetchCachePath(folder: String) -> URL? {
        guard
            let docs = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        else
        {
            return nil
        }
        
        let createdFolder = FolderCreator.createFolderIfNoneExists(url: docs.appendingPathComponent(folder).appendingPathComponent("files"))
        return createdFolder != nil ? createdFolder : docs
    }
}
