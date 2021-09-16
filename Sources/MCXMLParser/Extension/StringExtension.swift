//
//  File.swift
//  File
//
//  Created by Michael Craun on 9/12/21.
//

import Foundation

extension String {
    
    var formattedXML: String {
        
        let copy = self.replacingOccurrences(of: "\n", with: "")
        var formatted = ""
        var isInTag = false
        var isInValue = false
        
        for (index, char) in copy.enumerated() {
            if char == "<" {
                isInTag = true
                isInValue = false
            } else if char == ">" {
                let tagIndex = copy.index(copy.startIndex, offsetBy: index + 1)
                if index + 1 < copy.count {
                    if copy[tagIndex] != " " {
                        isInValue = true
                    }
                } else {
                    isInValue = false
                }
                isInTag = false
            }
            
            if isInTag || isInValue {
                formatted.append(char)
            } else if char != " " {
                formatted.append(char)
            }
        }
        
        return formatted
        
    }
    
    var xmlEncoding: String? {
        return nil
    }
    
    var xmlVersion: String? {
        return nil
    }
    
}
