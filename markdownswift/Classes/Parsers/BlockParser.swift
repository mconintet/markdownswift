//
//  BlockParser.swift
//  markdownswift
//
//  Created by mconintet on 4/20/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public class BlockParser: Parser {

    public override func parse(token: Token? = nil) -> [CodeNode]? {
        while true {
            guard let token = nextToken() else {
                return nil
            }

            if token.type == TokenType.CodeblockMd {
                // parse codeblock-md
                let parser = CodeblockMdParser(scanner)
                if let nodes = parser.parse(token) {
                    return nodes
                }
                return nil
            } else if token.type == TokenType.SpecialSymbol {
                if token == "#" {
                    // try to parse header-atx
                    markPosition()
                    var parser: Parser = HeaderAtxParser(scanner)
                    if let nodes = parser.parse(token) {
                        return nodes
                    }
                    applyPositionMarker()

                    parser = ParagraphParser(scanner)
                    guard let nodes = parser.parse(token) else {
                        fatalError("Deformed syntax")
                    }
                    return nodes
                } else if token == ">" {
                    // parse blockquote
                    let parser = BlockquoteParser(scanner)
                    guard let nodes = parser.parse(token) else {
                        fatalError("Deformed syntax")
                    }
                    return nodes
                } else if token == "*" {
                    return nil
                } else if token == "`" {
                    return nil
                }
            } else if token.type == .Space || token.type == .Newline {
                continue
            } else {
                // parse paragraph
                let parser = ParagraphParser(scanner)
                guard let nodes = parser.parse(token) else {
                    fatalError("Deformed syntax")
                }
                return nodes
            }
        }
    }
}
