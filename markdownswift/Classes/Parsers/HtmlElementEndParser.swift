//
//  HtmlElementEndParser.swift
//  markdownswift
//
//  Created by mconintet on 4/21/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public class HtmlElementEndParser: Parser {

    public override func parse(token: Token? = nil) -> [CodeNode]? {
        guard let token = nextToken() where token.type == .SpecialSymbol && token == "/" else {
            return nil
        }
        guard let next = nextToken() where token.type != .Space else {
            return nil
        }
        var nameTokens = [Token]()
        nameTokens.append(next)

        var nameOk = true
        var finished = false
        while true {
            guard let token = nextToken() else {
                break
            }
            if token.type == .Plaintext {
                if token.isAlphanumeric() {
                    nameTokens.append(token)
                } else {
                    nameOk = false
                    break
                }
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

        let node = CodeNode.nodeWithType(.HtmlElementEnd)
        node.attributes["name"] = String(name)
        if finished {
            return [node]
        }

        var foundCloseTag = false
        while true {
            guard let token = nextToken() else {
                break
            }
            if token.type == .SpecialSymbol && token == ">" {
                foundCloseTag = true
                break
            } else if token.type != .Space {
                break
            }
        }
        if foundCloseTag {
            return [node]
        }
        return nil
    }
}
