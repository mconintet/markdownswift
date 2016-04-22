//
//  HeaderSetextParser.swift
//  markdownswift
//
//  Created by mconintet on 4/20/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public class HeaderSetextParser: Parser {

    public override func parse(token: Token? = nil) -> [CodeNode]? {
        var textTokens = [Token]()

        if token != nil && token!.type != .Newline {
            textTokens.append(token!)
        }

        var symbol: Token?
        while true {
            guard let token = nextToken() else {
                break
            }
            if token.type == .Newline {
                guard let next = peekToken() else {
                    return nil
                }
                if next.type == TokenType.SpecialSymbol && (next == "=" || next == "-") {
                    nextToken()
                    var ok = true
                    symbol = next
                    while true {
                        guard let next = peekToken() else {
                            break
                        }
                        if next.type == .Newline {
                            break
                        } else if next.type != .SpecialSymbol || next != symbol {
                            ok = false
                            break
                        }
                        nextToken()
                    }
                    if !ok {
                        return nil
                    }
                    break
                } else {
                    return nil
                }
            } else {
                textTokens.append(token)
            }
        }

        guard let sym = symbol else {
            return nil
        }

        let node = CodeNode.nodeWithType(.HeaderSetext)
        node.attributes["symbol"] = sym
        node.content = textTokens

        skipMostNewline()
        return [node]
    }
}
