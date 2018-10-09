//
//  Cacher_Test.swift
//  MBNetworking
//
//  Created by Matt Beaney on 11/01/2018.
//

@testable import MBNetworking
import Foundation
import Quick
import Nimble
import UIKit
import CryptoSwift

class Cacher_Test : QuickSpec {
    override func spec() {
        describe("Caching tests") {
            //Clear all files at directory.
            beforeEach {
                guard let cache = self.fetchCachePath() else { return }
                
                for file in (try? FileManager.default.contentsOfDirectory(atPath: cache.path)) ?? [] {
                    do {
                        try FileManager.default.removeItem(atPath: cache.path + "/" + file)
                        print("Deleted")
                    } catch {
                        print("Errored: \(error)")
                        continue
                    }
                }
            }
            
            it("Should cache a file") {
                let url = URL(string: "http://google.com")!
                let data = "Test".data(using: .utf8)
                
                let ttlManager = TTLManager()
                Cacher(ttlManager: ttlManager).set(url: url, data: data!, secondsTTL: 10, type: "Test")
                
                guard
                    let cache = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    else
                {
                    fail()
                    return
                }
                
                let folderPath = cache  .appendingPathComponent("Test/")
                                        .appendingPathComponent("files")
                let fullPath = folderPath.appendingPathComponent("\(url.absoluteString.sha1()).dat")
                expect(try? Data(contentsOf: fullPath)).toNot(beNil())
            }
            
            it("Should fetch a cached file") {
                let url = URL(string: "http://google.com")!
                let data = "Test".data(using: .utf8)

                guard
                    let cache = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    else
                {
                    fail()
                    return
                }
                
                let folderPath = cache.appendingPathComponent("Test/")
                                    .appendingPathComponent("files")
                
                _ = FolderCreator.createFolderIfNoneExists(url: folderPath)
                let fullPath = folderPath.appendingPathComponent("\(url.absoluteString.sha1()).dat")
                
                do {
                    try? data?.write(to: fullPath)
                } catch {
                    print(error)
                }
                
                let ttlManager = TTLManager()
                let resultDownload = Cacher(ttlManager: ttlManager).get(url: url, type: "Test")
                
                if case let DownloadResult.success(data: data, response: _) = resultDownload {
                    expect(String(data: data, encoding: .utf8)).to(equal("Test"))
                } else {
                    fail()
                }
            }
            
            it("Should complete with nil error when nothing is found on disk.") {
                let url = URL(string: "http://google.com")!
                
                let ttlManager = TTLManager()
                let resultDownload = Cacher(ttlManager: ttlManager).get(url: url, type: "Test")
                
                if case let DownloadResult.failure(error: error) = resultDownload {
                    expect((error! as NSError).code).to(equal(Errors.Caching.NO_STORED_DATA.code))
                } else {
                    fail()
                }
            }
        }
    }
    
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
