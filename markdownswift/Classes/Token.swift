//
//  Token.swift
//  markdownswift
//
//  Created by mconintet on 4/20/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public class Token: Equatable, CustomStringConvertible {
    public let type: TokenType

    public private(set) var characters = [Character]()

    public init(_ char: Character, _ type: TokenType) {
        self.type = type
        characters.append(char)
    }

    public init(_ unicode: Int, _ type: TokenType) {
        self.type = type
        characters.append(Character(UnicodeScalar(unicode)))
    }

    public init(_ chars: [Character], _ type: TokenType) {
        self.type = type
        characters.appendContentsOf(chars)
    }

    public func isDigits() -> Bool {
        var ok = true
        for char in characters {
            if !Scanner.isDigitCharacter(char) {
                ok = false
                break
            }
        }
        return ok
    }

    public func isLetters() -> Bool {
        var ok = true
        for char in characters {
            if !Scanner.isLetter(char) {
                ok = false
                break
            }
        }
        return ok
    }

    public func isAlphanumeric() -> Bool {
        var ok = true
        for char in characters {
            if !Scanner.isLetter(char) && !Scanner.isDigitCharacter(char) {
                ok = false
                break
            }
        }
        return ok
    }

    public func toString() -> String {
        return "Token(type: \(type.self), value: \(characters))"
    }

    public var description: String {
        return toString()
    }
}

public func == (lhs: Token, rhs: Token) -> Bool {
    return lhs.characters == rhs.characters
}

public func == (lhs: Token, rhs: Character) -> Bool {
    if lhs.characters.count == 1 {
        return lhs.characters.first! == rhs
    }
    return false
}

public func == (lhs: Character, rhs: Token) -> Bool {
    if rhs.characters.count == 1 {
        return rhs.characters.first! == lhs
    }
    return false
}

func != (lhs: Token, rhs: Character) -> Bool {
    if lhs.characters.count == 1 {
        return !(lhs.characters.first! == rhs)
    }
    return true
}
