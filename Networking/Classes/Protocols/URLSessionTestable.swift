//
//  URLSessionTestable.swift
//  MBNetworking
//
//  Created by Matt Beaney on 11/01/2018.
//

import Foundation

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTaskWithURL(url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
    func dataTaskWithRequest(req: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}
