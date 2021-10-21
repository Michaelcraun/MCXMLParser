//
//  File.swift
//  
//
//  Created by Michael Craun on 10/12/21.
//

import Foundation

class MCXMLParser: NSObject {
    
    let document: MCXMLDocument
    let data: Data
    
    var currentParent: MCXMLElement?
    var currentElement: MCXMLElement?
    var currentValue = ""
    
    public init(document: MCXMLDocument, data: Data) {
        self.data = data
        self.document = document
        currentParent = document
    }
    
    func parse() throws {
        
        let parser = XMLParser(data: data)
        parser.delegate = self
        
        if parser.parse() {
            print("Successfully initialized document: \n\(document.xml)")
        } else {
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
        currentValue = ""
        currentElement = currentParent?.addElementWith(name: elementName, attributes: attributeDict)
        currentParent = currentElement
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue.append(string)
        currentElement?.value = currentValue.isEmpty ? nil : currentValue
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentParent = currentParent?.parent
        currentElement = nil
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
    }
    
    public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
    public func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        print(validationError.localizedDescription)
    }
    
}
