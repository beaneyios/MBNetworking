//
//  Errors.swift
//  MBNetworking
//
//  Created by Matt Beaney on 11/01/2018.
//

import Foundation

struct Errors {
    struct Network {
        static var SERVER_ERROR = CustomError(area: "NETWORK", description: "There was a server error", code: 101)
        static var INVALID_URL = CustomError(area: "NETWORK", description: "There was an invalid URL", code: 102)
        static var UNEXPECTED_RESPONSE = CustomError(area: "NETWORK", description: "There was an unexpected response from the server", code: 103)
        static var HOST_INVALID = CustomError(area: "NETWORK", description: "The host in the project is invalid", code: 104)
    }
    
    struct Caching {
        static var NO_CACHE = CustomError(area: "CACHING", description: "No content available offline.", code: 301)
        
        static var PATH_INVALID = NSError(domain: "NETWORK", code: 302, userInfo: ["description" : "Invalid caching path."])
        static var NO_STORED_DATA = NSError(domain: "com.mbnetworking.caching", code: 303, userInfo: ["description" : "No stored data."])
    }
}
