//
//  CodeblockMdParser.swift
//  markdownswift
//
//  Created by mconintet on 4/22/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public class CodeblockMdParser: Parser {

    public override func parse(token: Token?) -> [CodeNode]? {
        guard peekToken() != nil else {
            return nil
        }

        var tokens = [Token]()
        while true {
            guard let token = nextToken() else {
                break
            }
            if token.type == .Newline {
                guard let next = peekToken() else {
                    break
                }
                if next.type == .CodeblockMd {
                    nextToken()
                } else {
                    break
                }
            } else {
                tokens.append(token)
            }
        }
        let node = CodeNode.nodeWithType(.CodeblockMd)
        node.content = tokens
        return [node]
    }
}
