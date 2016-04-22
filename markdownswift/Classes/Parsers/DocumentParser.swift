//
//  DocumentParser.swift
//  markdownswift
//
//  Created by mconintet on 4/22/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public class DocumentParser: Parser {

    public override func parse(token: Token?) -> [CodeNode]? {
        let root = CodeNode.nodeWithType(.Document)
        while true {
            guard let nodes = BlockParser(scanner).parse() else {
                break
            }
            if let node = nodes.first where node.type == .Blockquote {
                if let last = root.children.last where last.type == .Blockquote {
                    last.addChildren(node.children)
                    continue
                }
            }
            root.addChildren(nodes)
        }
        return [root]
    }
}
