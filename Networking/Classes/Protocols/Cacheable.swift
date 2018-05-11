//
//  Cacheable.swift
//  GoodFruit
//
//  Created by Matt Beaney on 15/01/2018.
//  Copyright © 2018 PageSuite. All rights reserved.
//

import Foundation

protocol Cacheable {
    func get(url: URL, completion: DownloadCompletion)
    func set(url: URL, data: Data)
}
