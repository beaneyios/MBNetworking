//
//  TTLManager.swift
//  CryptoSwift
//
//  Created by Matt Beaney on 12/05/2018.
//

import Foundation

public class TTLManager: TTLManaging {
    public init() {}
    
    public func cacheInDate(url: URL, type: String) -> Bool {
        let hash = url.absoluteString.sha1()
        let fileName = self.fetchFileName(hash: hash)
        guard
            let currentTTLs = self.readTTLs(fileName: fileName, folder: type),
            let ttl = currentTTLs[hash]
        else {
            return false
        }
        
        let currentDate = Int(Date().timeIntervalSince1970)
        return currentDate < ttl
    }
    
    public func setTTL(url: URL, secondsTTL: Int, type: String) {
        let hash = url.absoluteString.sha1()
        let fileName = self.fetchFileName(hash: hash)
        let convertedTimeStamp = self.convertTTLToTimeStamp(secondsTTL: secondsTTL)
        guard var currentTTLs = self.readTTLs(fileName: fileName, folder: type) else {
            self.writeTTLs(ttls: [hash: convertedTimeStamp], fileName: fileName, folder: type)
            return
        }
        
        currentTTLs[url.absoluteString.sha1()] = convertedTimeStamp
        self.writeTTLs(ttls: currentTTLs, fileName: fileName, folder: type)
    }
    
    public func clearTTLs(type: String) {
        guard let cachePath = self.fetchTTLPath(folder: type) else {
            return
        }
        
        try? FileManager.default.removeItem(at: cachePath)
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
    
    fileprivate func readTTLs(fileName: String, folder: String) -> [String : Int]? {
        guard
            let cache = self.fetchTTLPath(folder: folder),
            let data = try? Data(contentsOf: self.fullPath(cache: cache, fileName: fileName)),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            else
        {
            return nil
        }
        
        return json as? [String : Int]
    }
    
    fileprivate func writeTTLs(ttls: [String : Int], fileName: String, folder: String) {
        guard
            let cache = self.fetchTTLPath(folder: folder),
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
    fileprivate func fetchTTLPath(folder: String) -> URL? {
        guard
            let docs = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            else
        {
            return nil
        }
        
        let createdFolder = FolderCreator.createFolderIfNoneExists(url: docs.appendingPathComponent(folder).appendingPathComponent("ttls"))
        return createdFolder != nil ? createdFolder : docs
    }
}
