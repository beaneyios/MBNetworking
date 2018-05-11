//
//  URLSession+Testability.swift
//  FBSnapshotTestCase
//
//  Created by Matt Beaney on 07/05/2018.
//

import Foundation

extension URLSession : URLSessionProtocol {
    func dataTaskWithRequest(req: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return (dataTask(with: req, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
    
    func dataTaskWithURL(url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}
extension URLSessionDataTask : URLSessionDataTaskProtocol {}
