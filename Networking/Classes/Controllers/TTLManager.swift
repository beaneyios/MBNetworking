//
//  TTLManager.swift
//  CryptoSwift
//
//  Created by Matt Beaney on 12/05/2018.
//

import Foundation

public class TTLManager: TTLManaging {
    public init() {}
    
    public func cacheInDate(url: URL) -> Bool {
        let hash = url.absoluteString.sha1()
        let fileName = self.fetchFileName(hash: hash)
        guard
            let currentTTLs = self.readTTLs(fileName: fileName),
            let ttl = currentTTLs[hash]
        else {
            return false
        }
        
        let currentDate = Int(Date().timeIntervalSince1970)
        return currentDate < ttl
    }
    
    public func setTTL(url: URL, secondsTTL: Int) {
        let hash = url.absoluteString.sha1()
        let fileName = self.fetchFileName(hash: hash)
        let convertedTimeStamp = self.convertTTLToTimeStamp(secondsTTL: secondsTTL)
        guard var currentTTLs = self.readTTLs(fileName: fileName) else {
            self.writeTTLs(ttls: [hash: convertedTimeStamp], fileName: fileName)
            return
        }
        
        currentTTLs[url.absoluteString.sha1()] = convertedTimeStamp
        self.writeTTLs(ttls: currentTTLs, fileName: fileName)
    }
    
    fileprivate func convertTTLToTimeStamp(secondsTTL: Int) -> Int {
        let timeInterval = Double(secondsTTL)
        let expiry = Date().addingTimeInterval(timeInterval).timeIntervalSince1970
        return Int(expiry)
    }
    
    fileprivate func fetchFileName(hash: String) -> String {
        if hash.count > 2 {
            let substr = String(describing: hash.prefix(3))
            return substr
        }
        
        return hash
    }
    
    fileprivate func readTTLs(fileName: String) -> [String : Int]? {
        guard
            let cache = self.fetchTTLPath(),
            let data = try? Data(contentsOf: self.fullPath(cache: cache, fileName: fileName)),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            else
        {
            return nil
        }
        
        return json as? [String : Int]
    }
    
    fileprivate func writeTTLs(ttls: [String : Int], fileName: String) {
        guard
            let cache = self.fetchTTLPath(),
            let data = try? JSONSerialization.data(withJSONObject: ttls, options: .prettyPrinted)
            else
        {
            return
        }
        
        try? data.write(to: self.fullPath(cache: cache, fileName: fileName), options: .atomic)
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
    fileprivate func fetchTTLPath() -> URL? {
        guard
            let docs = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            else
        {
            return nil
        }
        
        let createdFolder = FolderCreator.createFolderIfNoneExists(url: docs.appendingPathComponent("ttls"))
        return createdFolder != nil ? createdFolder : docs
    }
}
