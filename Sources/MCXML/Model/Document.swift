//
//  File.swift
//  File
//
//  Created by Michael Craun on 9/12/21.
//

import Foundation

public class MCXMLDocument: MCXMLElement {
    
    private var header: String {
        "<?xml version=\"\(version)\" encoding=\"\(encoding)\"?>"
    }
    
    public var encoding: String = "utf-8"
    public var version: String = "1.0"
    
    public var root: MCXMLElement {
        guard let root = children.first else {
            fatalError("Document has no root element!")
        }
        return root
    }
    
    public override var xml: String {
        var xml =  "\(header)\n"
        xml += root.xml
        return xml
    }
    
    /**
     * Default initializer for MCXMLDocument, This initializes an XML document with the most widely used parameters:
     * `version=1.0 encoding=utf-8`.
     */
    public init() {
        super.init(name: String(describing: MCXMLDocument.self))
    }
    
    public convenience init(data: Data) throws {
        self.init()
        let parser = MCXMLParser(document: self, data: data)
        try parser.parse()
    }
    
    /// Initializer for parsing an XML document from disk
    public convenience init(raw: String) throws {
        guard let data = raw.data(using: .utf8) else { throw MCXMLError.parseFailure }
        try self.init(data: data)
    }
    
    /// Initializer for creating an XML
    public convenience init(version: String, encoding: String) {
        self.init()
        self.encoding = encoding
        self.version = version
    }
    
}
