//
//  Cacheable.swift
//  MBNetworking
//
//  Created by Matt Beaney on 11/01/2018.
//

import Foundation

public protocol Cacheable {
    func get(url: URL, type: String) -> DownloadResult
    func set(url: URL, data: Data, secondsTTL: Int, type: String)
    func cacheInDate(url: URL, type: String) -> Bool
}
