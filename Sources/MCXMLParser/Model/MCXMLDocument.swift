//
//  File.swift
//  File
//
//  Created by Michael Craun on 9/12/21.
//

import Foundation

public class MCXMLDocument {
    
    var encoding: String?
    var version: String?
    
    var raw: String
    var elements: [MCXMLElement]
    
    /// Initializer for parsing an XML from disk
    public init(raw: String) {
        self.elements = []
        self.raw = raw.formattedXML
        
        self.encoding = raw.xmlEncoding
        self.version = raw.xmlVersion
    }
    
    /// Initializer for creating an XML
    public init(version: String, encoding: String) {
        self.encoding = encoding
        self.version = version
        
        self.elements = []
        self.raw = "<?xml version=\"\(version)\" encoding=\"\(encoding)\"?>\n"
    }
    
    func add(element: MCXMLElement) {
        element.level = 0
        self.elements.append(element)
    }
    
    func addElementWith(name: String, value: Any? = nil, attributes: [MCXMLAttribute] = [], toElementWith path: String? = nil) -> MCXMLDocument {
        
        if let path = path {
            if path.contains("/") {
                var pathComponents = path.components(separatedBy: "/")
                let rootComponent = pathComponents.removeFirst()
                var currentElement = self.elements.first(where: { $0.name == rootComponent })
                for component in pathComponents {
                    guard let index = currentElement?.children.firstIndex(where: { $0.name == component }) else {
                        print("MCXMLDocument - \(#function) could not find element with name: \(path)")
                        return self
                    }
                    currentElement = currentElement?.children[index]
                }
                
                guard let currentElement = currentElement else { fatalError() }
                currentElement.add(element: MCXMLElement(name: name, attributes: attributes, value: value, children: []))
            } else if let index = self.elements.firstIndex(where: { $0.name == path }) {
                self.elements[index].add(element: MCXMLElement(name: name, attributes: attributes, value: value, children: []))
            } else {
                print("MCXMLDocument - \(#function) could not find element with name: \(path)")
            }
        } else {
            self.add(element: MCXMLElement(name: name, attributes: attributes, value: value, children: []))
        }
        return self
        
    }
    
}

extension MCXMLDocument: CustomStringConvertible {
    
    public var description: String {
        let copy = raw
        let elements = elements.map { $0.raw }.joined(separator: "\n")
        return "\(copy)\(elements)"
    }
    
}
