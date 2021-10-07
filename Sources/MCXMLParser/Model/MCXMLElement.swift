//
//  File.swift
//  File
//
//  Created by Michael Craun on 9/12/21.
//

import Foundation

public class MCXMLElement {
    
    private var indent: String {
        if level == 0 {
            return ""
        }
        return (1...level).map { _ in "  " }.joined()
    }
    
    var name: String
    var attributes: [MCXMLAttribute] = []
    var value: Any? = nil
    var children: [MCXMLElement] = []
    var level: Int = 0 {
        didSet {
            for child in children {
                child.level = level + 1
            }
        }
    }
    
    var raw: String {
        let startTag = startTag()
        if children.isEmpty {
            if let value = value {
                return "\(startTag)\(value)</\(name)>"
            }
            return "\(startTag)</\(name)>"
        } else {
            let children = childrenTags()
            return """
            \(startTag)
            \(children)
            \(indent)<\(name)>
            """
        }
    }
    
    init(name: String, attributes: [MCXMLAttribute] = [], value: Any? = nil, children: [MCXMLElement] = []) {
        self.attributes = attributes
        self.name = name
        self.value = value
        
        for child in children {
            add(element: child)
        }
    }
    
    private func childrenTags() -> String {
        var tags = ""
        for child in children {
            let tag = child.raw
            tags += "\(tag)\(child == children.last ? "" : "\n")"
        }
        return tags
    }
    
    private func startTag() -> String {
        var tag = "\(indent)<\(name)"
        for attribute in attributes {
            if let bool = attribute.value as? Bool {
                tag += " \(attribute.name)=\"\(bool.cDescription)\""
            } else if let int = attribute.value as? Int {
                tag += " \(attribute.name)=\"\(int)\""
            } else if let string = attribute.value as? String {
                tag += " \(attribute.name)=\"\(string)\""
            } else {
                fatalError()
            }
        }
        return "\(tag)>"
        
    }
    
    func add(element: MCXMLElement) {
        element.level = level + 1
        self.children.append(element)
    }
    
    func addElementWith(name: String, value: Any? = nil, attributes: [MCXMLAttribute] = []) -> MCXMLElement {
        
        self.add(element: MCXMLElement(name: name, attributes: attributes, value: value, children: []))
        return self
        
    }
    
}

extension MCXMLElement: Equatable {
    public static func == (lhs: MCXMLElement, rhs: MCXMLElement) -> Bool {
        return lhs.name == rhs.name &&
            lhs.attributes == rhs.attributes &&
            lhs.children == rhs.children &&
            "\(String(describing: lhs.value))" == "\(String(describing: rhs.value))"
    }
}

extension MCXMLElement: CustomStringConvertible {
    public var description: String { raw }
}

extension MCXMLElement {
    subscript(_ name: String) -> MCXMLElement {
        for child in children {
            if child.name == name {
                return child
            }
        }
        fatalError("\(raw) does not contain child with name \(name)...")
    }
}

extension Array where Element == MCXMLElement {
    subscript(_ name: String) -> MCXMLElement {
        for element in self {
            for child in element.children {
                if child.name == name {
                    return child
                }
            }
        }
        fatalError("Could not find child with name \(name) in element!")
    }
}
