//
//  MockCacher.swift
//  MBNetworkingTests
//
//  Created by Matt Beaney on 11/01/2018.
//

@testable import MBNetworking
import Foundation

class MockCacher : Cacheable {
    var getCalled: Bool = false
    var setCalled: Bool = false
    
    func get(url: URL, type: String) -> DownloadResult {
        self.getCalled = true
        return DownloadResult.failure(error: nil)
    }
    
    func set(url: URL, data: Data, secondsTTL: Int, type: String) {
        self.setCalled = true
    }
    
    func cacheInDate(url: URL, type: String) -> Bool {
        return false
    }
}
