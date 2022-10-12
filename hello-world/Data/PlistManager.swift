//
//  PlistReader.swift
//  hello-world
//
//  Created by Taylor on 8/31/22.
//

import Foundation


class PlistManager {
    
    enum DataError: Error {
        case invalidPath
        case writeError
    }

    
    func read(fileNamed: String) throws -> [String: Any] {
        
        guard let path = Bundle.main.path(forResource: "Bill's PC", ofType: "plist") else { throw DataError.invalidPath }
        let plistData = FileManager.default.contents(atPath: path)
    
        var format = PropertyListSerialization.PropertyListFormat.xml
        
        let result = try PropertyListSerialization.propertyList(from: plistData!, options: .mutableContainersAndLeaves, format: &format) as! [String: Any]
        print(result)
        return result
    }
}
