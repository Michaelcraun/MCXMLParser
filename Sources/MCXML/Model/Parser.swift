//
//  File.swift
//  
//
//  Created by Michael Craun on 10/12/21.
//

import Foundation

class MCXMLParser: NSObject {
    
    var currentElement: MCXMLElement?
    var data: Data
    var document: MCXMLDocument
    
    public init(document: MCXMLDocument, data: Data) {
        
        self.data = data
        self.document = document
        
    }
    
    func parse() throws {
        
        let parser = XMLParser(data: data)
        parser.delegate = self
        
        if !parser.parse() {
            throw MCXMLError.parseFailure
        }
        
    }
    
}

extension MCXMLParser: XMLParserDelegate {
    
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
            self.document.elements.append(currentElement)
            self.currentElement = nil
        }
    }
    
    public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
    public func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        print(validationError.localizedDescription)
    }
    
}
