import XCTest
@testable import MCXML

final class MCXMLParserTests: XCTestCase {
    
    func testDocumentInitializationForCreation() {
        
        let defaultInit = MCXMLDocument()
        let specificParameters = MCXMLDocument(version: "2.0", encoding: "utf-16")
        
        XCTAssertEqual(defaultInit.encoding, "utf-8")
        XCTAssertEqual(defaultInit.version, "1.0")
        
        XCTAssertEqual(specificParameters.encoding, "utf-16")
        XCTAssertEqual(specificParameters.version, "2.0")
        
    }
    
    func testAddChildrenToDocument() {
        
        let document = MCXMLDocument()
        // Add a new child to a pre-existing document and capture a reference to the new child
        let _ = document.addElementWith(name: "foo")
        // Add a new child to a pre-existing document within the document withough capturing a reference
        document.addElementWith(name: "foo-2")
        
        XCTAssertEqual(
            document.xml.condensed,
            #"<?xml version="1.0" encoding="utf-8"?><foo></foo><foo-2></foo-2>"#)
        
    }
    
    func testAddElementsToElement() {
        
        let document = MCXMLDocument()
        let child = document.addElementWith(name: "foo")
        // Add a new child to a pre-existing element and capture a reference to the new child
        let childOfChild = child.addElementWith(name: "bar")
        // Add a new child to a pre-existing element without capturing a reference
        childOfChild.addElementWith(name: "foo-2")
        
        XCTAssertEqual(
            document.xml.condensed,
            #"<?xml version="1.0" encoding="utf-8"?><foo><bar><foo-2></foo-2></bar></foo>"#)
        
    }
    
    func testElementWithValue() {
        
        let boolElement = MCXMLElement(name: "foo", value: true)
        let doubleElement = MCXMLElement(name: "foo", value: 123.456)
        let intElement = MCXMLElement(name: "foo", value: 1)
        let stringElement = MCXMLElement(name: "foo", value: "bar")
        
        XCTAssertEqual(boolElement.value as? Bool, true)
        XCTAssertEqual(doubleElement.value as? Double, 123.456)
        XCTAssertEqual(intElement.value as? Int, 1)
        XCTAssertEqual(stringElement.value as? String, "bar")
        
    }
    
    func testElementsWithAttributes() {
        
        let dictionaryElement = MCXMLElement(name: "foo", attributes: ["bar" : 1])
        let attributesElement = MCXMLElement(name: "foo", attributes: [MCXMLAttribute(name: "bar", value: 1)])
        
        XCTAssertEqual(dictionaryElement.raw.condensed, #"<foo bar="1"></foo>"#)
        XCTAssertEqual(attributesElement.raw.condensed, #"<foo bar="1"></foo>"#)
        
    }
    
    func testXMLParse() {
        
        let path = Bundle.module.url(forResource: "barbarian", withExtension: "xml")!
        let contents = (try? String(contentsOf: path)) ?? ""
        
        guard let document = MCXMLDocument(raw: contents) else {
            XCTFail("Could not initialize document!")
            return
        }
        
        print(document.xml)
        
    }
    
    func testSubscripting() {
        
        let document = MCXMLDocument()
        let child = document.addElementWith(name: "foo")
        let childOfChild = child.addElementWith(name: "bar")
        childOfChild.addElementWith(name: "foo-2")
        
        let foo = document["foo"]
        let foobar = document["foo"]["bar"]
        let foo2 = foobar["foo-2"]
        
        XCTAssertEqual(foo.raw, child.raw)
        
        XCTAssertEqual(foobar.name, "bar")
        XCTAssertNil(foobar.value)
        
        XCTAssertEqual(foo2.name, "foo-2")
        XCTAssertNil(foo2.value)
        
    }
    
}
