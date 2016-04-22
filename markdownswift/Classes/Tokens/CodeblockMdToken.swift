//
//  CodeblockMdToken.swift
//  markdownswift
//
//  Created by mconintet on 4/22/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public class CodeblockMdToken: Token {

    public init(_ unicode: Int) {
        super.init(unicode, .CodeblockMd)
    }

    public init(_ char: Character) {
        super.init(char, .CodeblockMd)
    }

    public init(_ chars: [Character]) {
        super.init(chars, .CodeblockMd)
    }
}
