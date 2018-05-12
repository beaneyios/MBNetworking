//
//  FolderCreator.swift
//  MBNetworking
//
//  Created by Matt Beaney on 12/05/2018.
//

import Foundation

struct FolderCreator {
    static func createFolderIfNoneExists(url: URL) -> URL? {
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                return url
            } catch {
                return nil
            }
        }
        
        return url
    }
}
