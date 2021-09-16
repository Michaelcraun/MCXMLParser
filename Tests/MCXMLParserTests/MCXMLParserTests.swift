import XCTest
@testable import MCXMLParser

final class MCXMLParserTests: XCTestCase {
    
    func testRunningXMLCreation() {
        
        let document = MCXMLDocument(version: "1.0", encoding: "utf-8")
            .addElementWith(name: "compendium", attributes: [
                MCXMLAttribute(name: "version", value: 5),
                MCXMLAttribute(name: "auto_indent", value: false)])
            .addElementWith(name: "class", toElementWith: "compendium")
            .addElementWith(name: "name", value: "Barbarian", toElementWith: "compendium/class")
            .addElementWith(name: "hd", value: 12, toElementWith: "compendium/class")
            .addElementWith(name: "proficiency", value: "Strength, Constitution, Animal Handling, Athletics, Intimidation, Nature, Perception, Survival", toElementWith: "compendium/class")
            .addElementWith(name: "numSkills", value: 2, toElementWith: "compendium/class")
            .addElementWith(name: "autolevel", attributes: [MCXMLAttribute(name: "level", value: 1)], toElementWith: "compendium/class")
        
        print(document.description)
        
    }
    
    func testStaticXMLCreation() {
        
        let document = MCXMLDocument(version: "1.0", encoding: "utf-8")
        let compendium = MCXMLElement(name: "compendium", attributes: [
            MCXMLAttribute(name: "version", value: 5),
            MCXMLAttribute(name: "auto_indent", value: false)])
        let barbarian = MCXMLElement(name: "class", children: [
            MCXMLElement(name: "name", value: "Barbarian"),
            MCXMLElement(name: "hd", value: 12),
            MCXMLElement(name: "proficiency", value: "Strength, Constitution, Animal Handling, Athletics, Intimidation, Nature, Perception, Survival"),
            MCXMLElement(name: "numSkills", value: 2)
        ])
        let startingBarbarian = MCXMLElement(
            name: "autolevel",
            attributes: [MCXMLAttribute(name: "level", value: 1)],
            children: [MCXMLElement(name: "feature", attributes: [MCXMLAttribute(name: "optional", value: true)],
                                    children: [MCXMLElement(name: "name", value: "Starting Barbarian"),
                                               MCXMLElement(name: "text", value: "As a 1st-level Barbarian, you begin play with 12+your Constitution modifier hit points."),
                                               MCXMLElement(name: "text"),
                                               MCXMLElement(name: "text", value: "You are proficient with the following items, in addition to any proficiencies provided by your race or background."),
                                               MCXMLElement(name: "text", value: "• Armor: light, medium, shields"),
                                               MCXMLElement(name: "text", value: "• Weapons: simple, martial"),
                                               MCXMLElement(name: "text", value: "• Tools: none"),
                                               MCXMLElement(name: "text", value: "• Skills: Choose 2 from Animal Handling, Athletics, Intimidation, Nature, Perception, Survival"),
                                               MCXMLElement(name: "text"),
                                               MCXMLElement(name: "text", value: "You begin play with the following equipment, in addition to any equipment provided by your background."),
                                               MCXMLElement(name: "text", value: "• (a) a greataxe or (b) any martial melee weapon"),
                                               MCXMLElement(name: "text", value: "• (a) two handaxe or (b) any simple weapon"),
                                               MCXMLElement(name: "text", value: "• An explorer's pack, and four javelin"),
                                               MCXMLElement(name: "text"),
                                               MCXMLElement(name: "text", value: "Alternatively, you may start with 2d4 x 10 gp and choose your own equipment."),
                                               MCXMLElement(name: "text"),
                                               MCXMLElement(name: "text", value: "Source: Player's Handbook p. 46")])])
        
        
        document.add(element: compendium)
        compendium.add(element: barbarian)
        barbarian.add(element: startingBarbarian)
        
        print(document.description)
        
    }
    
    func testXMLParse() {
        
        let rawXML = #"""
        <?xml version='1.0' encoding='utf-8'?>
        <compendium version="5" auto_indent="NO">
            <class>
                <name>Barbarian</name>
                <hd>12</hd>
                <proficiency>Strength, Constitution</proficiency>
                <numSkills>2</numSkills>
                <autolevel level="1">
                    <feature optional="YES">
                        <name>Starting Barbarian</name>
                        <text>As a 1st-level Barbarian</text>
                        <text></text>
                    </feature>
                </autolevel>
            </class>
        </compendium>
        """#
        
        let document = MCXMLDocument(raw: rawXML)
        print(document.raw)
        
    }
    
}
