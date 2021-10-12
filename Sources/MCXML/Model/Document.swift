//
//  File.swift
//  File
//
//  Created by Michael Craun on 9/12/21.
//

import Foundation

public class MCXMLDocument: NSObject {
    
    private var currentElement: MCXMLElement?
    var raw: String
    
    public var elements: [MCXMLElement] = [] {
        didSet {
            print(elements.count)
        }
    }
    public var encoding: String?
    public var version: String?
    
    public var xml: String {
        let copy = raw
        let elements = elements.map { $0.raw }.joined(separator: "\n")
        return "\(copy)\(elements)"
    }
    
    /**
     * Default initializer for MCXMLDocument, This initializes an XML document with the most widely used parameters:
     * `version=1.0 encoding=utf-8`.
     */
    public override init() {
        self.encoding = "utf-8"
        self.version = "1.0"
        self.raw = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    }
    
    /// Initializer for parsing an XML document from disk
    public init(raw: String) throws {
        self.raw = raw
        super.init()
        
        guard let data = raw.data(using: .utf8) else { throw MCXMLError.parseFailure }
        let parser = MCXMLParser(document: self, data: data)
        try parser.parse()
    }
    
    /// Initializer for creating an XML
    public init(version: String, encoding: String) {
        self.encoding = encoding
        self.version = version
        self.raw = "<?xml version=\"\(version)\" encoding=\"\(encoding)\"?>\n"
    }
    
    @discardableResult
    public func add(element: MCXMLElement) -> MCXMLElement {
        element.level = 0
        self.elements.append(element)
        return element
    }
    
    @discardableResult
    public func addElementWith(name: String, value: Any? = nil, attributes: [MCXMLAttribute] = []) -> MCXMLElement {
        return self.add(
            element: MCXMLElement(
                name: name,
                attributes: attributes,
                value: value,
                children: []))
    }
    
    public subscript(_ childName: String) -> MCXMLElement {
        guard let element = elements.first(where: { $0.name == childName }) else {
            fatalError("Could not find element with name \(childName) in document!")
        }
        return element
    }
    
}
