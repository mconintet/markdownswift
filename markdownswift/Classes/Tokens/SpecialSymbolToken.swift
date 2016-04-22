//
//  SpecialSymbolToken.swift
//  markdownswift
//
//  Created by mconintet on 4/22/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

// <>/&;=-#*.[]():_`!\
public class SpecialSymbolToken: Token {

    public init(_ unicode: Int) {
        super.init(unicode, .SpecialSymbol)
    }

    public init(_ char: Character) {
        super.init(char, .SpecialSymbol)
    }

    public init(_ chars: [Character]) {
        super.init(chars, .SpecialSymbol)
    }
}
