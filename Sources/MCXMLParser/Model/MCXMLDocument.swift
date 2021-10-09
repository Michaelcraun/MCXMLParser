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
    
    public var encoding: String?
    public var version: String?
    
    public var raw: String
    public var elements: [MCXMLElement]
    
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
    
    public func add(element: MCXMLElement) {
        element.level = 0
        self.elements.append(element)
    }
    
    public func addElementWith(name: String, value: Any? = nil, attributes: [MCXMLAttribute] = [], toElementWith path: String? = nil) -> MCXMLDocument {
        
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
    
    public func parse(_ completion: @escaping MCXMLDocumentParsingCompletion) {
        
        self.onParsed = completion
        
        guard let data = raw.data(using: .utf8) else { return }
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        
    }
    
}

extension MCXMLDocument {
    
    public override var description: String {
        let copy = raw
        let elements = elements.map { $0.raw }.joined(separator: "\n")
        return "\(copy)\(elements)"
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
        return nil
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
