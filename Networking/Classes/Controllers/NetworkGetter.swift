//
//  Getter.swift
//  GoodFruit
//
//  Created by Matt Beaney on 11/01/2018.
//  Copyright © 2018 PageSuite. All rights reserved.
//

import Foundation

public class NetworkGetter : Getter {
    public init() {}
    
    /**
     Returns an appropriate colour for a given background colour.
     - parameter URL: the URL that should be called.
     - parameter timeout: A timeout in seconds, this will be split in 2 and used partly for the request, and partly for the resource download.
     - parameter completion: The completion for the request, this takes Data or Error
     */
    func get(url: URL, timeout: Double, completion: @escaping DownloadCompletion) -> URLSessionDataTaskProtocol? {
        let details = self.fetchRequest(for: url, timeout: timeout)
        return get(req: details.1, session: details.0, completion: completion)
    }
    
    /**
     Returns an appropriate colour for a given background colour.
     - parameter req: the request that needs to be made.
     - parameter session: A session protocol.
     - parameter completion: The completion for the request, this takes Data or Error
     - returns a URLSession for any potential cancelling of tasks.
     */
    func get(req: URLRequest, session: URLSessionProtocol, completion: @escaping DownloadCompletion) -> URLSessionDataTaskProtocol? {
        let task = session.dataTaskWithRequest(req: req) { (data, response, error) in
            if let data = data, let response = response as? HTTPURLResponse {
                let result = DownloadResult.success(data: data, response: response)
                completion(result)
            } else if let error = error {
                let result = DownloadResult.failure(error: error)
                completion(result)
            }
        }
        
        task.resume()
        return task
    }
    
    /**
     Returns an appropriate colour for a given background colour.
     - parameter url: the URL for which we need to build a request.
     - parameter timeout: A timeout in seconds, this will be split in 2 and used partly for the request, and partly for the resource download.
     - returns: a session and URL request.
     */
    func fetchRequest(for url: URL, timeout: Double) -> (URLSession, URLRequest) {
        let req = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringCacheData
        config.timeoutIntervalForRequest = timeout / 2
        config.timeoutIntervalForResource = timeout / 2
        let session = URLSession(configuration: config)
        return (session, req)
    }
}
