//
//  TTLManaging.swift
//  CryptoSwift
//
//  Created by Matt Beaney on 12/05/2018.
//

import Foundation

public protocol TTLManaging {
    func setTTL(url: URL, secondsTTL: Int)
    func cacheInDate(url: URL) -> Bool
}
