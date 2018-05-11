//
//  URLSessionTestable.swift
//  GoodFruit
//
//  Created by Matt Beaney on 11/01/2018.
//  Copyright © 2018 PageSuite. All rights reserved.
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
