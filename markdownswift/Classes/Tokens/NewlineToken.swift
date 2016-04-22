//
//  NewlineToken.swift
//  markdownswift
//
//  Created by mconintet on 4/22/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public class NewlineToken: Token {

    public init(_ unicode: Int) {
        super.init(unicode, .Newline)
    }

    public init(_ char: Character) {
        super.init(char, .Newline)
    }

    public init(_ chars: [Character]) {
        super.init(chars, .Newline)
    }
}
