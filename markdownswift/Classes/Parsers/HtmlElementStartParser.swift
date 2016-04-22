//
//  HtmlElementStartParser.swift
//  markdownswift
//
//  Created by mconintet on 4/21/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public class HtmlElementStartParser: Parser {

    public override func parse(token: Token? = nil) -> [CodeNode]? {
        guard let token = nextToken() else {
            return nil
        }

        var nameTokens = [Token]()
        if token.type == .Space {
            return nil
        }
        nameTokens.append(token)

        var nameOk = true
        var finished = false
        while true {
            guard let token = nextToken() else {
                break
            }
            if token.type == .Plaintext {
                if token.isAlphanumeric() {
                    nameOk = false
                    break
                } else {
                    nameTokens.append(token)
                }
            } else if token.type == .Space {
                break
            } else if token.type == .SpecialSymbol && token == ">" {
                finished = true
                break
            } else if token.type == .Space {
                break
            } else {
                nameTokens.append(token)
            }
        }

        if !nameOk {
            return nil
        }

        var name = [Character]()
        for token in nameTokens {
            name.appendContentsOf(token.characters)
        }

        let node = CodeNode.nodeWithType(.HtmlElementStart)
        node.attributes["name"] = String(name)
        if finished {
            return [node]
        }

        // skip attrs
        var foundCloseTag = false
        while true {
            guard let token = nextToken() else {
                break
            }
            if token.type == .SpecialSymbol && token == ">" {
                foundCloseTag = true
                break
            }
        }
        if foundCloseTag {
            return [node]
        }
        return nil
    }
}
