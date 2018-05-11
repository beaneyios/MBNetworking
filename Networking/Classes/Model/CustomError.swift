//
//  Errors.swift
//  GoodFruit
//
//  Created by Matt Beaney on 11/01/2018.
//  Copyright © 2018 PageSuite. All rights reserved.
//

import Foundation

struct CustomError {
    var area: String
    var description: String
    var code: Int
    
    init(area: String, description: String, code: Int) {
        self.area           = area
        self.description    = description
        self.code           = code
    }
}
