//
//  HtmlElementParser.swift
//  markdownswift
//
//  Created by mconintet on 4/20/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public class HtmlElementParser: Parser {
    static var legalVoidElements = ["br", "hr", "img"]
    static var legalNormalElements = ["p", "div", "h",
        "blockquote", "pre", "table",
        "dl", "ol", "ul", "address",
        "strong", "b", "em"]

    public override func parse(token: Token? = nil) -> [CodeNode]? {
        guard let nodes = HtmlElementStartParser(scanner).parse(token) where nodes.count == 1 else {
            return nil
        }
        let startName = nodes[0].attributes["name"] as! String
        if HtmlElementParser.legalVoidElements.contains(startName) {
            let node = CodeNode.nodeWithType(.HtmlVoidElement)
            node.attributes["name"] = startName
            return [node]
        }

        var end: CodeNode?
        var contentTokens = [Token]()
        while true {
            guard let token = nextToken() else {
                break
            }
            if token.type == .SpecialSymbol && token == "<" {
                beginCaptureToken()
                if let endTag = HtmlElementEndParser(scanner).parse(token)?.first {
                    let endName = endTag.attributes["name"] as! String
                    if endName == startName {
                        end = endTag
                        break
                    }
                }
                contentTokens.append(token)
                if let captured = capturedTokens() {
                    contentTokens.appendContentsOf(captured)
                }
                endCaptureToken()
            } else {
                contentTokens.append(token)
            }
        }
        if end == nil {
            return nil
        }

        // continue parse content
        let node = CodeNode.nodeWithType(.HtmlElement)
        node.attributes["name"] = startName

        let tokenSanner = TokenScanner(contentTokens)
        var textNode = CodeNode.nodeWithType(.Text)
        var textContent = [Token]()
        while true {
            guard let token = tokenSanner.nextToken() else {
                break
            }
            if token.type == .SpecialSymbol && token == "<" {
                let parser = HtmlElementParser(tokenSanner)
                tokenSanner.beginCaptureToken()
                if let nodes = parser.parse(token) {
                    textNode.content = textContent
                    node.addChild(textNode)

                    textContent = [Token]()
                    textNode = CodeNode.nodeWithType(.Text)

                    node.addChildren(nodes)
                } else {
                    textContent.append(token)
                    if let captured = tokenSanner.capturedTokens() {
                        textContent.appendContentsOf(captured)
                    }
                }
                tokenSanner.endCaptureToken()
            } else {
                textContent.append(token)
            }
        }

        if textContent.count > 0 {
            textNode.content = textContent
            node.addChild(textNode)
        }
        return [node]
    }

    static public func isLegalElement(element: String) -> Bool {
        return legalVoidElements.contains(element) || legalNormalElements.contains(element)
    }
}
