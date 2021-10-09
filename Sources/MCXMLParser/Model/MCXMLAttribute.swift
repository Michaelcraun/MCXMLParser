//
//  File.swift
//  File
//
//  Created by Michael Craun on 9/12/21.
//

import Foundation

public struct MCXMLAttribute {
    
    var name: String
    var value: Any
    var children: [MCXMLElement]?
    
    public init(name: String, value: Any, children: [MCXMLElement]? = nil) {
        self.children = children
        self.name = name
        self.value = value
    }
    
}

extension MCXMLAttribute: Equatable {
    public static func == (lhs: MCXMLAttribute, rhs: MCXMLAttribute) -> Bool {
        lhs.name == rhs.name && lhs.children == rhs.children
    }
}
