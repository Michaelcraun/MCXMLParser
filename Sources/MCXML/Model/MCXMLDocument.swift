//
//  File.swift
//  File
//
//  Created by Michael Craun on 9/12/21.
//

import Foundation

public class MCXMLDocument: NSObject {
    
    public typealias MCXMLDocumentParsingCompletion = (Error?) -> Void
    
    private var onParsed: MCXMLDocumentParsingCompletion?
    private var currentElement: MCXMLElement?
    var raw: String
    
    public var elements: [MCXMLElement]
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
        self.elements = []
        self.encoding = "utf-8"
        self.version = "1.0"
        self.raw = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    }
    
    /// Initializer for parsing an XML from disk
    public init(raw: String) {
        self.elements = []
        self.raw = raw
        
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
    
    public func parse(_ completion: @escaping MCXMLDocumentParsingCompletion) {
        
        self.onParsed = completion
        
        guard let data = raw.data(using: .utf8) else { return }
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        
    }
    
}

extension MCXMLDocument: XMLParserDelegate {
    
    public func parser(_ parser: XMLParser, foundComment comment: String) {
        fatalError("\(#function) is not handled! Please create an issue on GitHub!")
    }
    
    public func parser(_ parser: XMLParser, foundElementDeclarationWithName elementName: String, model: String) {
        fatalError("\(#function) is not handled! Please create an issue on GitHub!")
    }
    
    public func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        fatalError("\(#function) is not handled! Please create an issue on GitHub!")
    }
    
    public func parser(_ parser: XMLParser, didEndMappingPrefix prefix: String) {
        fatalError("\(#function) is not handled! Please create an issue on GitHub!")
    }
    
    public func parser(_ parser: XMLParser, foundProcessingInstructionWithTarget target: String, data: String?) {
        fatalError("\(#function) is not handled! Please create an issue on GitHub!")
    }
    
    public func parser(_ parser: XMLParser, foundInternalEntityDeclarationWithName name: String, value: String?) {
        fatalError("\(#function) is not handled! Please create an issue on GitHub!")
    }
    
    public func parser(_ parser: XMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String) {
        fatalError("\(#function) is not handled! Please create an issue on GitHub!")
    }
    
    public func parser(_ parser: XMLParser, resolveExternalEntityName name: String, systemID: String?) -> Data? {
        fatalError("\(#function) is not handled! Please create an issue on GitHub!")
    }
    
    public func parser(_ parser: XMLParser, foundNotationDeclarationWithName name: String, publicID: String?, systemID: String?) {
        fatalError("\(#function) is not handled! Please create an issue on GitHub!")
    }
    
    public func parser(_ parser: XMLParser, foundExternalEntityDeclarationWithName name: String, publicID: String?, systemID: String?) {
        fatalError("\(#function) is not handled! Please create an issue on GitHub!")
    }
    
    public func parser(_ parser: XMLParser, foundUnparsedEntityDeclarationWithName name: String, publicID: String?, systemID: String?, notationName: String?) {
        fatalError("\(#function) is not handled! Please create an issue on GitHub!")
    }
    
    public func parser(_ parser: XMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?) {
        fatalError("\(#function) is not handled! Please create an issue on GitHub!")
    }
    
    
    
    
    
    public func parserDidStartDocument(_ parser: XMLParser) {
        
    }
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        let element = MCXMLElement(name: elementName)
        if !attributeDict.isEmpty {
            element.attributes = attributeDict.map { key, value in
                MCXMLAttribute(name: key, value: value)
            }
        }
        
        if let currentElement = currentElement {
            if currentElement.children.isEmpty {
                currentElement.children.append(element)
            } else {
                currentElement.children.last?.children.append(element)
            }
        } else {
            self.currentElement = element
        }
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if let currentElement = currentElement {
            if currentElement.children.isEmpty {
                currentElement.value = string
            } else {
                currentElement.children.last?.value = string
            }
        }
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if let currentElement = currentElement, currentElement.name == elementName {
            self.currentElement = nil
        }
    }
    
    public func parserDidEndDocument(_ parser: XMLParser) {
        onParsed?(nil)
    }
    
    public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        onParsed?(parseError)
    }
    
    public func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        onParsed?(validationError)
    }
    
}

extension MCXMLDocument {
    subscript(_ name: String) -> MCXMLElement {
        for element in elements {
            if element.name == name {
                return element
            }
        }
        fatalError("Could not find element with name \(name) in document...")
    }
}
