//
//  Errors.swift
//  MBNetworking
//
//  Created by Matt Beaney on 11/01/2018.
//

import Foundation

public struct CustomError {
    var area: String
    var description: String
    var code: Int
    
    public init(area: String, description: String, code: Int) {
        self.area           = area
        self.description    = description
        self.code           = code
    }
}
