//
//  TokenType.swift
//  markdownswift
//
//  Created by mconintet on 4/22/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public enum TokenType: Int {
    case Space
    case Newline
    case SpecialSymbol // <>/&;=-#*.[]():_`!\
    case Plaintext
    case CodeblockMd
    case OrderedList
}
