//
//  HeaderAtxParser.swift
//  markdownswift
//
//  Created by mconintet on 4/20/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public class HeaderAtxParser: Parser {

    public override func parse(token: Token? = nil) -> [CodeNode]? {
        guard let token = nextToken() else {
            return nil
        }

        var content = [Token]()
        var hashCount = 1
        if token == "#" {
            hashCount += 1
            while true {
                guard let next = peekToken() else {
                    return nil
                }
                if next == "#" {
                    nextToken()
                    hashCount += 1
                } else if next.type == .Space {
                    nextToken()
                } else {
                    nextToken()
                    content.append(next)
                    break
                }
            }
        }

        if currentToken()!.type == .Newline && content.count == 0 {
            return nil
        }

        let node = CodeNode.nodeWithType(.HeaderAtx)
        node.attributes["hashCount"] = hashCount

        var closeHash = [Token]()
        while true {
            guard let token = nextToken() else {
                break
            }
            if token.type == .Newline {
                break
            } else if token == "#" {
                closeHash.append(token)
            } else {
                content.appendContentsOf(closeHash)
                content.append(token)
                if closeHash.count > 0 {
                    closeHash = [Token]()
                }
            }
        }

        while true {
            guard let last = content.last else {
                break
            }
            if last.type == .Space {
                content.popLast()
            } else {
                break
            }
        }

        node.content = content

        skipMostNewline()
        return [node]
    }
}
