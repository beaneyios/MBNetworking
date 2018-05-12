//
//  TTLManaging.swift
//  CryptoSwift
//
//  Created by Matt Beaney on 12/05/2018.
//

import Foundation

public protocol TTLManaging {
    func setTTL(url: URL, secondsTTL: Int, type: String)
    func cacheInDate(url: URL, type: String) -> Bool
    func clearTTLs(type: String)
}
