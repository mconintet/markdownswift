//
//  ParagraphParser.swift
//  markdownswift
//
//  Created by mconintet on 4/20/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public class ParagraphParser: Parser {

    public override func parse(token: Token? = nil) -> [CodeNode]? {
        guard peekToken() != nil else {
            return nil
        }

        var ret = [CodeNode]()
        var p = CodeNode.nodeWithType(.Paragraph)
        var pContent = [Token]()

        if token?.type == .Plaintext {
            pContent.append(token!)
        }

        while true {
            guard let token = peekToken() else {
                break
            }
            if token.type == .SpecialSymbol && token == "<" {
                nextToken()
                // try parse html
                beginCaptureToken()
                let parser = HtmlElementParser(scanner)
                if let nodes = parser.parse(token) {
                    if pContent.count > 0 {
                        p.content = pContent
                        ret.append(p)

                        p = CodeNode.nodeWithType(.Paragraph)
                        pContent = [Token]()
                    }

                    ret.appendContentsOf(nodes)
                } else {
                    pContent.append(token)
                    if let captured = capturedTokens() {
                        pContent.appendContentsOf(captured)
                    }
                }
            } else if currentToken() == nil || currentToken()!.type == .Newline {
                if (token.type == .SpecialSymbol && (token == "#" || token == ">" || token == "*"))
                || token.type == .OrderedList || token.type == .Newline {
                    pContent.popLast()
                    break
                } else if token.type == .Space || token.type == .CodeblockMd {
                    var emptyLine = true
                    beginCaptureToken()
                    while true {
                        guard let next = nextToken() else {
                            break
                        }
                        if next.type == .Newline {
                            break
                        }
                        if next.type != .Space && next.type != .CodeblockMd {
                            emptyLine = false
                            break
                        }
                    }
                    if emptyLine {
                        break
                    } else {
                        if let captured = capturedTokens() {
                            pContent.appendContentsOf(captured)
                        }
                    }
                    endCaptureToken()
                }
                nextToken()
                beginCaptureToken()
                let parser = HeaderSetextParser(scanner)
                if let nodes = parser.parse(token) {
                    if pContent.count > 0 {
                        p.content = pContent
                        ret.append(p)

                        p = CodeNode.nodeWithType(.Paragraph)
                        pContent = [Token]()
                    }
                    ret.appendContentsOf(nodes)
                } else {
                    pContent.append(token)
                    if let captured = capturedTokens() {
                        pContent.appendContentsOf(captured)
                    }
                }
                endCaptureToken()
            } else {
                nextToken()
                pContent.append(token)
            }
        }
        if pContent.count > 0 {
            while true {
                guard let last = pContent.last where last.type == .Newline else {
                    break
                }
                pContent.popLast()
            }
            p.content = pContent
            ret.append(p)
        }
        return ret
    }
}
