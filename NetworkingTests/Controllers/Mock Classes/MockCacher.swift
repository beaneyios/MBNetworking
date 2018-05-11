//
//  MockCacher.swift
//  GoodFruitTests
//
//  Created by Matt Beaney on 15/01/2018.
//  Copyright © 2018 PageSuite. All rights reserved.
//

@testable import MBNetworking
import Foundation

class MockCacher : Cacheable {
    var getCalled: Bool = false
    var setCalled: Bool = false
    
    func get(url: URL, completion: (DownloadResult) -> ()) {
        self.getCalled = true
        completion(DownloadResult.failure(error: nil))
    }
    
    func set(url: URL, data: Data) {
        self.setCalled = true
    }
}
