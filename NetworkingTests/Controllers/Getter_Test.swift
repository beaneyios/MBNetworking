//
//  Getter_Test.swift
//  MBNetworkingTests
//
//  Created by Matt Beaney on 11/01/2018.
//

@testable import MBNetworking
import Foundation
import Quick
import Nimble

class Getter_Test: QuickSpec {
    override func spec() {
        describe("GET Tests") {
            it("Should resume the session when called.", closure: {
                let nextDataTask = MockURLSessionDataTask()
                let mockSession = MockURLSession()
                mockSession.nextDataTask = nextDataTask
                
                let url = URL(string: "http://google.com")!
                let req = URLRequest(url: url)
                
                let _ = NetworkGetter().get(req: req, session: mockSession, completion: { (result) in })
                expect(nextDataTask.hasResumed).to(beTrue())
            })
            
            it("should return data for a valid URL in a GET request") {
                let nextDataTask = MockURLSessionDataTask()
                let mockSession = MockURLSession()
                mockSession.nextDataTask = nextDataTask
                
                let expectedData = "{}".data(using: String.Encoding.utf8)
                mockSession.nextData = expectedData
                
                let url = URL(string: "http://google.com")!
                let req = URLRequest(url: url)
                
                var actualData: Data?
                let _ = NetworkGetter().get(req: req, session: mockSession, completion: { (result) in
                    if case let DownloadResult.success(data: data, response: _) = result {
                        actualData = data
                    }
                })
                
                expect(actualData).toEventually(equal(expectedData))
            }
            
            it("should error when a network request fails") {
                let nextDataTask = MockURLSessionDataTask()
                let mockSession = MockURLSession()
                mockSession.nextDataTask = nextDataTask
                
                let expectedError = NSError(domain: "test", code: 500, userInfo: [:]) as Error
                mockSession.nextError = expectedError
                
                let url = URL(string: "http://google.com")!
                let req = URLRequest(url: url)
                
                var actualError: Error?
                let _ = NetworkGetter().get(req: req, session: mockSession, completion: { (result) in
                    if case let DownloadResult.failure(error: error) = result {
                        actualError = error
                    }
                })
                
                expect(actualError).toEventually(be(expectedError))
            }
            
            it("should return a shared session and formed request for a URL") {
                let getter = NetworkGetter()
                guard let url = URL(string: "http://google.com") else {
                    fail("URL didn't work")
                    return
                }
                
                let details = getter.fetchRequest(for: url, timeout: 4.0)
                expect(details.0.configuration.requestCachePolicy).to(equal(NSURLRequest.CachePolicy.reloadIgnoringCacheData))
                expect(details.0.configuration.timeoutIntervalForRequest).to(equal(2.0))
                expect(details.0.configuration.timeoutIntervalForResource).to(equal(2.0))
            }
        }
    }
}
