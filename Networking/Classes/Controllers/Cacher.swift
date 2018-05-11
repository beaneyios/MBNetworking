//
//  CacheGetter.swift
//  MBNetworking
//
//  Created by Matt Beaney on 15/01/2018.
//

import Foundation
import CryptoSwift

public class Cacher : Cacheable {
    
    /**
     Fetches data from the disk.
     - parameter url: The URL for which data needs to be fetched.
     - parameter completion: A closure that can either take data or an error.
     */
    public func get(url: URL, completion: (DownloadResult) -> ()) {
        guard let cache = self.fetchCachePath() else {
            completion(.failure(error: Errors.Caching.PATH_INVALID))
            return
        }
        
        guard
            let cachedData = try? Data(contentsOf: self.fullPath(cache: cache, url: url)),
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            else
        {
            completion(.failure(error: Errors.Caching.NO_STORED_DATA))
            return
        }
        
        completion(.success(data: cachedData, response: response))
    }
    
    /**
     Writes data to the disk.
     - parameter url: The URL for which data needs to be stored.
     - parameter data: The data representation of the contents of the URL.
     */
    public func set(url: URL, data: Data) {
        guard let cache = self.fetchCachePath() else {
            return
        }
        
        try? data.write(to: self.fullPath(cache: cache, url: url), options: .atomic)
    }
    
    /**
     Fetches the full URL, given the URL and cache URL.
     - parameter cache: The URL for the caches folder
     - parameter url: The URL.
     - returns: The full URL path
     */
    fileprivate func fullPath(cache: URL, url: URL) -> URL {
        return cache.appendingPathComponent("\(url.absoluteString.sha1()).dat")
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
        
        return docs
    }
}
