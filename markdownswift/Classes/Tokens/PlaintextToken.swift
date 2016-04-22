//
//  PlaintextToken.swift
//  markdownswift
//
//  Created by mconintet on 4/22/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public class PlaintextToken: Token {

    public init(_ unicode: Int) {
        super.init(unicode, .Plaintext)
    }

    public init(_ char: Character) {
        super.init(char, .Plaintext)
    }

    public init(_ chars: [Character]) {
        super.init(chars, .Plaintext)
    }
}
