//
//  DataFetching.swift
//  GoodFruit
//
//  Created by Matt Beaney on 11/01/2018.
//  Copyright © 2018 PageSuite. All rights reserved.
//

import Foundation

typealias DownloadCompletion = (_ result: DownloadResult) -> ()

enum DownloadResult {
    case success(data: Data, response: HTTPURLResponse)
    case failure(error: Error?)
}

protocol Getter {
    func get(url: URL, timeout: Double, completion: @escaping DownloadCompletion) -> URLSessionDataTaskProtocol?
    func get(req: URLRequest, session: URLSessionProtocol, completion: @escaping DownloadCompletion) -> URLSessionDataTaskProtocol?
}
