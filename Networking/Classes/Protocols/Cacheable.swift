//
//  Cacheable.swift
//  MBNetworking
//
//  Created by Matt Beaney on 11/01/2018.
//

import Foundation

protocol Cacheable {
    func get(url: URL, completion: DownloadCompletion)
    func set(url: URL, data: Data)
}
