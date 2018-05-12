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
    
    public func cacheInDate(url: URL) -> Bool {
        if case DownloadResult.failure(error: _) = self.get(url: url) { return false }
        return ttlManager.cacheInDate(url: url)
    }
    
    /**
     Fetches data from the disk.
     - parameter url: The URL for which data needs to be fetched.
     - parameter completion: A closure that can either take data or an error.
     */
    public func get(url: URL) -> DownloadResult {
        guard let cache = self.fetchCachePath() else {
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
    public func set(url: URL, data: Data, secondsTTL: Int) {
        guard let cache = self.fetchCachePath() else {
            return
        }
        
        self.ttlManager.setTTL(url: url, secondsTTL: secondsTTL)
        try? data.write(to: self.fullPath(cache: cache, fileName: url.absoluteString.sha1()), options: .atomic)
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
    fileprivate func fetchCachePath() -> URL? {
        guard
            let docs = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        else
        {
            return nil
        }
        
        let createdFolder = FolderCreator.createFolderIfNoneExists(url: docs.appendingPathComponent("files"))
        return createdFolder != nil ? createdFolder : docs
    }
}
