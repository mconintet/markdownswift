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
        let processLastNewline = {
            while true {
                guard let last = pContent.last where last.type == .Newline else {
                    break
                }
                pContent.popLast()
            }
        }

        var capturedCount = 0
        if token?.type == .Plaintext {
            pContent.append(token!)
            capturedCount = 1
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
                        processLastNewline()
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
                            capturedCount = captured.count
                            pContent.appendContentsOf(captured)
                        } else {
                            capturedCount = 0
                        }
                    }
                    endCaptureToken()
                }
            }
            beginCaptureToken()
            let parser = HeaderSetextParser(scanner)
            if let nodes = parser.parse(nil) {
                let hContent = pContent.suffix(capturedCount)
                pContent = Array(pContent.prefix(pContent.count - capturedCount))
                if pContent.count > 0 {
                    processLastNewline()
                    p.content = pContent
                    ret.append(p)

                    p = CodeNode.nodeWithType(.Paragraph)
                    pContent = [Token]()
                }
                guard let header = nodes.first else {
                    return nil
                }
                if hContent.count > 0 {
                    header.content.insertContentsOf(hContent, at: 0)
                }
                ret.append(header)
                continue
            } else {
                capturedCount = 0
                pContent.append(token)
                if let captured = capturedTokens() {
                    pContent.appendContentsOf(captured)
                }
            }
            endCaptureToken()
        }
        if pContent.count > 0 {
            processLastNewline()
            p.content = pContent
            ret.append(p)
        }
        return ret
    }
}
