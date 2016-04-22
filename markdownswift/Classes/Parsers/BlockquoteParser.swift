//
//  BlockquoteParser.swift
//  markdownswift
//
//  Created by mconintet on 4/20/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public class BlockquoteParser: Parser {

    public override func parse(token: Token?) -> [CodeNode]? {
        guard peekToken() != nil else {
            return nil
        }
        let node = CodeNode.nodeWithType(.Blockquote)
        var tokens = [Token]()
        while true {
            guard let token = nextToken() else {
                break
            }
            if token.type == .Newline && (previousToken() == nil || previousToken()!.type == .Newline) {
                break
            } else if token.type == .SpecialSymbol && token == ">"
            && (previousToken() == nil || previousToken()!.type == .Newline) {
                guard let next = peekToken() where next.type == .Space else {
                    continue
                }
                nextToken()
                let space = next as! SpaceToken
                if space.spaceCount() > 4 {
                    let splitTokens = space.splitToCodeblockMd(1)
                    tokens.appendContentsOf(splitTokens)
                }
            } else {
                tokens.append(token)
            }
        }
        if tokens.count > 0 {
            let tokenScanner = TokenScanner(tokens)
            while true {
                guard let nodes = BlockParser(tokenScanner).parse(nil) else {
                    break
                }
                node.addChildren(nodes)
            }
        }
        return [node]
    }
}
