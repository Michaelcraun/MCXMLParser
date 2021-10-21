//
//  File.swift
//  File
//
//  Created by Michael Craun on 9/12/21.
//

import Foundation

extension String {
    
    /// A single-line representation of a given XML String
    var condensed: String { self.replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "") }
    
    var containsEndTag: Bool { contains("</") }
    
    var elements: [MCXMLElement] {
        // Get the raw elements and remove the declaration
        let components = self.rawElements.filter { !$0.isXmlDeclaration }
        var elements: [MCXMLElement] = []
        var currentElement: MCXMLElement!
        
        for component in components {
            if component.containsEndTag {
                // Component is either 1-line XML (has opening AND closing tags) or is the closing tag for a previously configured element
                if let name = component.elementName {
                    if let currentElement = currentElement, currentElement.name == name {
                        // Component is end tag for current element
                    } else {
                        // Component is one-line XML
                        let element = MCXMLElement(name: name, attributes: component.elementAttributes, value: component.elementValue)
                        if let currentElement = currentElement {
                            currentElement.children.append(element)
                        } else {
                            elements.append(element)
                        }
                    }
                }
            } else {
                // Component is opening tag for a collection of children elements
                guard let name = component.elementName else { continue }
                currentElement = MCXMLElement(name: name, attributes: component.elementAttributes, value: component.elementValue)
            }
        }
        
        return elements
    }
    
    var elementAttributes: [MCXMLAttribute] {
        if isXmlDeclaration {
            return []
        }
        
        var trimmed = self
            .replacingOccurrences(of: ">", with: "")
            .replacingOccurrences(of: "</", with: "")
            .replacingOccurrences(of: "<", with: "")
        
        if let name = elementName {
            trimmed = trimmed.replacingOccurrences(of: name, with: "")
        }
        
        if let value = elementValue {
            trimmed = trimmed.replacingOccurrences(of: value, with: "")
        }
        
        // Everything left over should be the element's attributes
        if trimmed.count > 0 && trimmed.contains("=") {
            let attributes = trimmed
                .trimmingCharacters(in: .whitespaces)
                .components(separatedBy: " ")
            return attributes.map { attr in
                let components = attr.components(separatedBy: "=")
                let cleanValue = components[1].replacingOccurrences(of: "\"", with: "")
                return MCXMLAttribute(name: components[0], value: cleanValue, children: nil)
            }
        }
        return []
    }
    
    var elementName: String? {
        // Should return nil if element is ONLY end tag
        let openings = filter { $0 == "<" }
        if openings.count == 1 && !contains("/") || openings.count > 1 {
            let trimmed = self.replacingOccurrences(of: "<", with: "")
            if let range = trimmed.range(of: "^\\w+", options: .regularExpression) {
                return String(trimmed[range])
            }
        }
        return nil
    }
    
    var elementValue: String? {
        if let elementName = elementName, self.contains("</") {
            // Element contains both opening and closing tags, so should also contain value
            // Might be an empty value, though...
            return self.replacingOccurrences(of: elementName, with: "")
                .replacingOccurrences(of: "</", with: "")
                .replacingOccurrences(of: ">", with: "")
                .replacingOccurrences(of: "<", with: "")
        }
        return nil
    }
    
    var isXmlDeclaration: Bool {
        contains("<?xml version=") &&
        contains(" encoding=") &&
        contains("?>")
    }
    
    /// The individual elemenrs of an XML String with extraneous whitespace removed
    var rawElements: [String] {
        let elements: [String] = self.rawElementsWithWhitespace
        var formattedElements: [String] = []
        
        for element in elements {
            var formattedElement = ""
            var isInTag = false
            var isInValue = false
            
            for (index, char) in element.enumerated() {
                if char == "<" {
                    isInTag = true
                    isInValue = false
                } else if char == ">" {
                    let tagIndex = element.index(element.startIndex, offsetBy: index + 1)
                    if index + 1 < element.count {
                        if element[tagIndex] != " " {
                            isInValue = true
                        }
                    } else {
                        isInValue = false
                    }
                    isInTag = false
                }
                
                if isInTag || isInValue {
                    formattedElement.append(char)
                } else if char != " " {
                    formattedElement.append(char)
                }
            }
            
            formattedElements.append(formattedElement)
            formattedElement = ""
        }
        
        return formattedElements
    }
    
    var rawElementsWithWhitespace: [String] {
        self.components(separatedBy: "\n")
    }
    
    var xmlElement: MCXMLElement? {
        if let elementName = elementName {
            return MCXMLElement(name: elementName, attributes: [], value: elementValue)
        }
        return nil
    }
    
    var xmlEncoding: String? {
        if var declaration = rawElements.first(where: { $0.isXmlDeclaration }), let version = xmlVersion {
            declaration.removeSubrange(declaration.range(of: "<?xml version=")!)
            declaration.removeSubrange(declaration.range(of: " encoding=")!)
            declaration.removeSubrange(declaration.range(of: "?>")!)
            declaration.removeSubrange(declaration.range(of: version)!)
            return declaration.replacingOccurrences(of: "'", with: "")
                .replacingOccurrences(of: "`", with: "")
                .replacingOccurrences(of: "\"", with: "")
        }
        return nil
    }
    
    var xmlVersion: String? {
        if let declaration = rawElements.first(where: { $0.isXmlDeclaration }) {
            if let range = declaration.range(of: "[0-9]{1,}.[0-9]{1,}|[0-9]{1,}", options: .regularExpression) {
                return String(declaration[range])
            }
        }
        return nil
    }
    
    func truncated(length: Int = 100, trailing: String = "...") -> String {
        (self.count > length) ? self.prefix(length) + trailing : self
    }
    
}
