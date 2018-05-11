//
//  Mock_URLSession_Classes.swift
//  MBNetworkingTests
//
//  Created by Matt Beaney on 11/01/2018.
//

@testable import MBNetworking
import Foundation

class MockURLSession : URLSessionProtocol {
    var nextData: Data?
    var nextError: Error?
    var nextDataTask: URLSessionDataTaskProtocol = MockURLSessionDataTask()
    var nextReq: URLRequest?
    
    func dataTaskWithURL(url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        let response = HTTPURLResponse()
        completionHandler(nextData, response, nextError)
        return self.nextDataTask
    }
    
    func dataTaskWithRequest(req: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        self.nextReq = req
        let response = HTTPURLResponse()
        completionHandler(nextData, response, nextError)
        return self.nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    var hasResumed: Bool = false
    var hasCancelled: Bool = false
    
    func resume() {
        self.hasResumed = true
    }
    
    func cancel() {
        self.hasCancelled = true
    }
}
