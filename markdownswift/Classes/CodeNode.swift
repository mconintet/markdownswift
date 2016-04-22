//
//  CodeNode.swift
//  markdownswift
//
//  Created by mconintet on 4/20/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public enum CodeNodeType: Int {
    case Document

    case Text

    case HeaderSetext
    case HeaderAtx

    case Paragraph
    case Blockquote

    case CodeblockMd
    case CodeblockExt

    case List
    case ListOlItem
    case ListUlItem

    case HtmlElement
    case HtmlVoidElement

    case HtmlNormalElement
    case HtmlElementStart
    case HtmlElementEnd

    case IllegalHtmlElement
}

public class CodeNode: CustomStringConvertible {
    public let type: CodeNodeType
    public var content = [Token]()

    public weak var parent: CodeNode?
    public var children = [CodeNode]()
    public var attributes = [String: Any]()

    static let indentation = "    "

    private init(_ type: CodeNodeType) {
        self.type = type
    }

    static func nodeWithType(type: CodeNodeType) -> CodeNode {
        let node = CodeNode(type)
        return node
    }

    public func addChild(node: CodeNode) {
        node.parent = self
        children.append(node)
    }

    public func addChildren(nodes: [CodeNode]) {
        for node in nodes {
            addChild(node)
        }
    }

    public static func indentationWithDepth(depth: Int) -> String {
        var ret = ""
        for _ in 0 ..< depth {
            ret += indentation
        }
        return ret
    }

    public func xmlStringWithDepth(depth: Int) -> String {
        let indentation = CodeNode.indentationWithDepth(depth)
        let indentation1 = CodeNode.indentationWithDepth(depth + 1)
        let indentation2 = CodeNode.indentationWithDepth(depth + 2)

        var ret = "\(indentation)<\(type.self)>\n"

        if attributes.count > 0 {
            ret += "\(indentation1)<Attributes>\n"
            for (key, value) in attributes {
                ret += "\(indentation2)<Key>\(key)</key>\n"
                ret += "\(indentation2)<Value>\(value)</value>\n"
            }
            ret += "\(indentation1)</Attributes>\n"
        }

        if content.count > 0 {
            ret += "\(indentation1)<Content>\(content)</Content>\n"
        }

        if children.count > 0 {
            ret += "\(indentation1)<Children>\n"
            for child in children {
                ret += child.xmlStringWithDepth(depth + 2)
            }
            ret += "\(indentation1)</Children>\n"
        }

        ret += "\(indentation)</\(type.self)>\n"
        return ret
    }

    public var description: String {
        return xmlStringWithDepth(0)
    }
}
