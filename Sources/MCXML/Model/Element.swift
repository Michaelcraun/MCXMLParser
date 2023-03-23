//
//  File.swift
//  File
//
//  Created by Michael Craun on 9/12/21.
//

import Foundation

public class MCXMLElement {
    
    public var parent: MCXMLElement?
    
    public var children: [MCXMLElement] = []
    
    public var name: String
    
    public var value: Any? = nil
    
    public var attributes: [MCXMLAttribute] = []
    
    public var xml: String {

        var xml = String()
        
        // open element
        xml += indent
        xml += "<\(name)"
        
        if attributes.count > 0 {
            // insert attributes
            for attribute in attributes {
                xml += " \(attribute.name)=\"\(attribute.value)\""
            }
        }
        
        if value == nil && children.count == 0 {
            // close element
            xml += " />"
        } else {
            if children.count > 0 {
                // add children
                xml += ">\n"
                for child in children {
                    xml += "\(child.xml)\n"
                }
                // add indentation
                xml += indent
                xml += "</\(name)>"
            } else {
                // insert string value and close element
                xml += ">\(value ?? "")</\(name)>"
            }
        }
        
        return xml
        
    }
    
    var parents: [MCXMLElement] {
        
        var parents: [MCXMLElement] = []
        var element = self
        while let parent = element.parent {
            parents.append(parent)
            element = parent
        }
        return parents
        
    }
    
    private var indent: String {
        return parents.count <= 1 ? "" : (2...parents.count).map { _ in "\t" }.joined()
    }
    
    public init(name: String) {
        self.name = name
    }
    
    public convenience init(name: String, attributes: [MCXMLAttribute]) {
        self.init(name: name)
        self.attributes = attributes
    }
    
    public convenience init(name: String, children: [MCXMLElement]) {
        self.init(name: name)
        self.children = children
    }
    
    public convenience init(name: String, attributes: [MCXMLAttribute], children: [MCXMLElement]) {
        self.init(name: name, attributes: attributes)
        self.children = children
    }
    
    public convenience init(name: String, value: Any?) {
        self.init(name: name)
        self.value = value
    }
    
    public convenience init(name: String, attributes: [MCXMLAttribute], value: Any?) {
        self.init(name: name, attributes: attributes)
        self.value = value
    }
    
    public convenience init(name: String, attributes: [MCXMLAttribute], value: Any?, children: [MCXMLElement]) {
        self.init(name: name, attributes: attributes, value: value)
        self.children = children
    }
    
    public convenience init(name: String, attributes: [String : Any]) {
        self.init(name: name)
        self.attributes = attributes.map { MCXMLAttribute(name: $0, value: $1) }
    }
    
    public convenience init(name: String, attributes: [String : Any], value: Any?) {
        self.init(name: name, attributes: attributes)
        self.value = value
    }
    
    public convenience init(name: String, attributes: [String : Any], value: Any?, children: [MCXMLElement]) {
        self.init(name: name, attributes: attributes, value: value)
        self.children = children
    }
    
    private func childrenTags() -> String {
        var tags = ""
        for child in children {
            let tag = child.xml
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
    
    @discardableResult
    public func add(element: MCXMLElement) -> MCXMLElement {
        element.parent = self
        children.append(element)
        return element
    }
    
    @discardableResult
    public func addElementWith(name: String) -> MCXMLElement {
        return add(element: MCXMLElement(name: name))
    }
    
    @discardableResult
    public func addElementWith(name: String, value: Any?) -> MCXMLElement {
        return add(element: MCXMLElement(name: name, value: value))
    }
    
    @discardableResult
    public func addElementWith(name: String, attributes: [String : Any]) -> MCXMLElement {
        return add(element: MCXMLElement(name: name, attributes: attributes))
    }
    
    @discardableResult
    public func addElementWith(name: String, value: Any?, attributes: [MCXMLAttribute]) -> MCXMLElement {
        return add(element: MCXMLElement(name: name, attributes: attributes, value: value))
    }
    
    @discardableResult
    public func addElementWith(name: String, value: Any?, attributes: [String : Any]) -> MCXMLElement {
        return add(element: MCXMLElement(name: name, attributes: attributes, value: value))
    }
    
    public subscript(_ child: String) -> MCXMLElement? {
        guard let child = children.first(where: { $0.name == child }) else { return nil }
        return child
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
