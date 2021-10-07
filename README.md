# MCXMLParser

> A Swift Package for importing and exporting XML files into Swift applications. 

I created this package because I needed a simple way to read and write XML files and want to avoid using Cocoapods in an application I was working on. Please note that I am no master or even adept with XML and there may be bugs within this package as well as feature implementations that aren't finished. If you'd like to help out, you can do so. See the `Further Development/Assistance` section below! :)

[![Swift Version][swift-image]][swift-url]
[![Build Status][travis-image]][travis-url]
[![License][license-image]][license-url]
[![codebeat-badge][codebeat-image]][codebeat-url]

## Installation

Add this project on your `Package.swift`

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/Michaelcraun/MCXMLParser.git", majorVersion: 0, minor: 0)
    ]
)
```

Alternatively, you can add this package to your Xcode project directly by clicking `File > Swift Packages > Add Package Dependency...` and pasting the link to this repository (`https://github.com/Michaelcraun/MCXMLParser.git`) in the dialog box.

## Usage examples

Using `MCXMLParser`, you can easily read and write XML documents. Reading an XML document is as easy as creating an instance of `MCXMLDocument` from a raw XML String and invoking the `parse(_:)` function. When finished, you can use all of the functionality an `MCXMLDocument` offers. 

```swift
import MCXMLParser

func load() {
    guard let url = Bundle.main.url(forResource: "file", withExtension: "xml"), 
          let contents = try? String(contentsOf: url) else { return }
    
    let document = MCXMLDocument(raw: contents)
    document.parse { error in 
        if error == nil {
            // Use document
        }
    }
}
```

Creating and modifying an XML document can be accomplished in various ways after creating a new instance of `MCXMLDocument`. You can:
- Chain multiple `add(element:)` or `addElementWith(name:)` calls on the `MCXMLDocument` (and its children)
- Create instances of `MCXMLElements` manually and add them one-by-one to either the `MCXMLDocument` or a created instance of `MCXMLElement`

```swift
import MCXMLParser

func createByChainingElements() {
    let document = MCXMLDocument(version: "1.0", encoding: "UTF-8")
    document.add(element: MCXMLElement(name: "foo")
        .add(element: MCXMLElement(name: "bar")
    )
}

func createManually() {
    let document = MCXMLDocument(version: "1.0", encoding: "UTF-8")
    let foo = MCXMLElement(name: "foo")
    let bar = MCXMLElement(name: "bar")
    
    foo.add(element: bar)
    document.add(element: foo)
}
``` 

`MCXMLParser` also handles XML attributes and values on all instances of `MCXMLElement`. Attributes and values can be added directly in the initializer of `MCXMLElement` or constructed and added later. Values for both `MCXMLElement` and `MCXMLAttribute` instances are handled intelligently and automatically type-casted into an appropriate type. For example, if the a child of the XML you are parsing has attributes of `foo="5" bar="true"`, these values will be automatically type-cated into an Int and Bool, respectively.

```swift
import MCXMLParser

var childWithAttributesAndValue: MCXMLElement {
    return MCXMLElement(
        name: "foo",
        attributes: [MCXMLAttribute(name: "bar", value: 1),
        value: true)
}

func set(attributes: [MCXMLAttribute], andValue value: Any, ofChild child: MCXMLElement) {
    child.attributes = attributes
    child.value = value
}
```

<!--### Limitations-->
<!---->
<!--**Number of Dice.** While testing, I found that a number of dice with 6 or more digits took almost a full second to calculate the rolls, so numbers with more than 5 digits have been disabled within this project. When the user attempts to enter a 6th digit while using the calculator, nothing happens.   -->

## Further Development/Assitance

If you would like to contribute to this project, please feel free to do so. I believe strongly in open-source collaboration! :)
Before opening your PR, please create an issue within GitHub with the `enhancement` label applied.
When creating your PR, please include a short note about what you changed and why it's made this package better.
Please also include a streamlined test for demonstrating your changes.

For a list of planned changes and updates, please see the current list of [open issues](https://github.com/Michaelcraun/MCXMLParser/issues) on GitHub.

## Release History

<!--* 0.1.2-->
<!--    * Added support for button fonts-->
<!--* 0.1.1-->
<!--    * Updated README-->
<!--    * Added completion handler for rolled value-->
<!--    * Added update handler for formula-->
<!--* 0.1.0-->
<!--    * The first official release-->
<!--* 0.0.6-->
<!--    * Fixed some logic issues caused by previous update-->
<!--* 0.0.5-->
<!--    * Fixed some layout issues-->
<!--* 0.0.4-->
<!--    * Fixed public availability of needed functionality-->
<!--* 0.0.3-->
<!--    * Fixed iOS dependency issues-->
<!--    * *NOTE:* Minimum iOS version is now iOS 14.0-->
<!--* 0.0.2-->
<!--    * Fixed iOS dependency issues-->
<!--    * *NOTE:* Minimum iOS version is now iOS 13.0-->
<!-- * 0.0.1
    * Work in progress -->

## Meta

Michael Craun – [@opkurix](https://twitter.com/opkurix) – michael.craun@gmail.com

Distributed under the GNU GPLv3 license. See ``LICENSE`` for more information.

### Copyright
The material used in this package (and more specifically it's tests) is Open Game Conent, and is licensed for public use under the terms of the Open Game License v1.0a Copyright 2000, Wizards of the Coast, Inc. Please visit [Wizards of the Coast](https://media.wizards.com/2016/downloads/DND/SRD-OGL_V5.1.pdf) for more information regarding the OGL.

[https://github.com/Michaelcraun/github-link](https://github.com/Michaelcraun/)

[swift-image]:https://img.shields.io/badge/swift-3.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: https://spdx.org/licenses/GPL-3.0-or-later.html
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
