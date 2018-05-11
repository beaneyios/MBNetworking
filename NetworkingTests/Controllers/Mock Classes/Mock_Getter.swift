//
//  Mock_Getter.swift
//  GoodFruitTests
//
//  Created by Matt Beaney on 11/01/2018.
//  Copyright © 2018 PageSuite. All rights reserved.
//

@testable import MBNetworking
import Foundation

class MockGetter : Getter {
    var shouldFail: Bool = false
    var data: Data?
    var response: HTTPURLResponse?
    
    func get(url: URL, timeout: Double, completion: @escaping DownloadCompletion) -> URLSessionDataTaskProtocol? {
        if let validData = self.data {
            completion(.success(data: validData, response: self.response ?? HTTPURLResponse()))
        } else {
            let error = NSError(domain: "noData", code: 1001, userInfo: nil)
            completion(.failure(error: error))
        }
        
        return nil
    }
    
    func get(req: URLRequest, session: URLSessionProtocol, completion: @escaping DownloadCompletion) -> URLSessionDataTaskProtocol? {
        return nil
    }
}
