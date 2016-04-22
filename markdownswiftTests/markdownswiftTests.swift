//
//  markdownswiftTests.swift
//  markdownswiftTests
//
//  Created by mconintet on 4/20/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import XCTest
@testable import markdownswift

class markdownswiftTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func readFileContent(file: String) -> String {
        do {
            let bundle = NSBundle(forClass: markdownswiftTests.self)
            let path = bundle.pathForResource(file, ofType: "md")
            return try String(contentsOfFile: path!)
        } catch {
            fatalError("Failed to read file \(file)")
        }
    }

    func testScanner() {
        let test = readFileContent("test")
        let scanner = Scanner(StringSource(test))
        while true {
            guard let token = scanner.nextToken() else {
                break
            }
            print(token)
        }
    }

    func testCodeNode() {
        let root = CodeNode.nodeWithType(.Document)
        let paragraph = CodeNode.nodeWithType(CodeNodeType.Paragraph)
        let html = CodeNode.nodeWithType(CodeNodeType.HtmlElement)
        paragraph.addChild(html)
        root.addChild(paragraph)
        print(root)
    }

    func testBlockParser() {
        let test = readFileContent("test")
        let scanner = Scanner(StringSource(test))
        let parser = BlockParser(scanner)
        if let nodes = parser.parse(nil) {
            print(nodes)
        } else {
            print("none")
        }
    }

    func testHeaderSetextParser() {
        let test = readFileContent("test")
        let scanner = Scanner(StringSource(test))
        let parser = HeaderSetextParser(scanner)
        if let nodes = parser.parse(nil) {
            print(nodes)
        } else {
            print("none")
        }
    }

    func testParagraphParser() {
        let test = readFileContent("test")
        let scanner = Scanner(StringSource(test))
        let parser = HtmlElementParser(scanner)
        if let nodes = parser.parse(nil) {
            print(nodes)
        } else {
            print("none")
        }
    }

    func testHtmlParser() {
        let test = readFileContent("test")
        let scanner = Scanner(StringSource(test))
        let parser = ParagraphParser(scanner)
        if let nodes = parser.parse(nil) {
            print(nodes)
        } else {
            print("none")
        }
    }

    func testBlockquoteParser() {
        let test = readFileContent("test")
        let scanner = Scanner(StringSource(test))
        let parser = BlockquoteParser(scanner)
        if let nodes = parser.parse(nil) {
            print(nodes)
        } else {
            print("none")
        }
    }

    func testDocumentParser() {
        let test = readFileContent("test")
        let scanner = Scanner(StringSource(test))
        let parser = DocumentParser(scanner)
        if let nodes = parser.parse(nil) {
            print(nodes)
        } else {
            print("none")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
}
