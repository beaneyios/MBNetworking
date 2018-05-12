//
//  Cacheable.swift
//  MBNetworking
//
//  Created by Matt Beaney on 11/01/2018.
//

import Foundation

public protocol Cacheable {
    func get(url: URL) -> DownloadResult
    func set(url: URL, data: Data, secondsTTL: Int)
    func cacheInDate(url: URL) -> Bool
}
