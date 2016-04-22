//
//  SpaceToken.swift
//  markdownswift
//
//  Created by mconintet on 4/22/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public class SpaceToken: Token {
    public static var tabWidth = Array<Character>(count: 4, repeatedValue: " ")

    public init(_ unicode: Int) {
        super.init(unicode, .Space)
        processTab()
    }

    public init(_ char: Character) {
        super.init(char, .Space)
        processTab()
    }

    public init(_ chars: [Character]) {
        super.init(chars, .Space)
        processTab()
    }

    public func processTab() {
        var ret = [Character]()
        for char in characters {
            if char == "\t" {
                ret.appendContentsOf(SpaceToken.tabWidth)
            } else {
                ret.append(char)
            }
        }
    }

    public func spaceCount() -> Int {
        return characters.count
    }

    public func splitToCodeblockMd(dropSpaceFromRemain: Int = 0) -> [Token] {
        var ret = [Token]()
        var count = spaceCount()
        if count < 4 {
            return ret
        }
        var token: Token = CodeblockMdToken(SpaceToken.tabWidth)
        ret.append(token)
        count -= 4 + dropSpaceFromRemain
        if count > 0 {
            let chars = Array<Character>(count: count, repeatedValue: " ")
            token = SpaceToken(chars)
            ret.append(token)
        }
        return ret
    }
}
