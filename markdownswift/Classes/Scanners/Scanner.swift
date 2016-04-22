//
//  Scanner.swift
//  markdownswift
//
//  Created by mconintet on 4/21/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public class Scanner: ScannerProtocol {
    static let digitCharacterSet = "0123456789".toCharacters()
    static let lowercaseLetterCharacterSet = "abcdefghijklmnopqrstuvwxyz".toCharacters()
    static let uppercaseLetterCharacterSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".toCharacters()
    static let whiteSpaceSet = " \t\n\r".toCharacters()

    static let specialSymbolSet = "<>/&;=-#*.[]():_`!\\".toCharacters()

    public let source: SourceProtocol

    public private(set) var isPeek = false

    public private(set) var previousToken: Token? = nil

    public private(set) var currentToken: Token? = nil {
        didSet {
            if isPeek {
                currentToken = oldValue
                return
            }
            previousToken = oldValue
            guard let token = currentToken else {
                return
            }
            guard var last = captureTokenStack.popLast() else {
                return
            }
            last.append(token)
            captureTokenStack.append(last)
        }
    }

    public private(set) var captureTokenStack = [[Token]]()

    public init(_ source: SourceProtocol) {
        self.source = source
    }

    public func markPosition() {
        source.markPosition()
    }

    public func applyPositionMarker() {
        source.applyPositionMarker()
    }

    public func discardPositionMarker() {
        source.discardPositionMarker()
    }

    public func markedCharacters() -> [Character]? {
        return source.markedCharacters()
    }

    public func beginCaptureToken() {
        captureTokenStack.append([Token]())
    }

    public func endCaptureToken() {
        captureTokenStack.popLast()
    }

    public func capturedTokens() -> [Token]? {
        return captureTokenStack.last
    }

    public func nextToken() -> Token? {
        var token: Token? = nil
        guard let char = source.nextCharacter() else {
            return token
        }

        switch char {
        case " ":
            if currentToken == nil || currentToken!.type == .Newline {
                var skipped = skipCharacters(" ".toCharacters(), count: 3)
                skipped.append(char)
                if skipped.count == 4 {
                    token = CodeblockMdToken(skipped)
                    currentToken = token
                    return token
                }
                guard let next = source.peekCharacter() else {
                    token = SpaceToken(skipped)
                    currentToken = token
                    return token
                }
                if next == "\t" {
                    source.nextCharacter()
                    skipped.append("\t")
                    token = CodeblockMdToken(skipped)
                    currentToken = token
                    return token
                } else {
                    token = SpaceToken(skipped)
                    currentToken = token
                    return token
                }
            } else {
                var skipped = skipMostCharacters(" \t".toCharacters())
                skipped.append(char)
                token = SpaceToken(skipped)
                currentToken = token
                return token
            }
        case "\t":
            if currentToken == nil || currentToken!.type == .Newline {
                token = CodeblockMdToken(char)
                currentToken = token
                return token
            } else {
                token = PlaintextToken(char)
                currentToken = token
                return token
            }
        case "\r":
            guard let next = source.peekCharacter() else {
                token = NewlineToken(char)
                currentToken = token
                return token
            }
            if next == "\n" {
                source.nextCharacter()
                token = NewlineToken(["\r", "\n"])
                currentToken = token
                return token
            } else {
                token = NewlineToken(char)
                currentToken = token
                return token
            }
        case "\n":
            token = NewlineToken(char)
            currentToken = token
            return token
        case "\\":
            guard let next = source.peekCharacter() else {
                token = PlaintextToken(char)
                currentToken = token
                return token
            }
            if Scanner.isSpecialSymbol(next) {
                source.nextCharacter()
                token = PlaintextToken(next)
                currentToken = token
                return token
            } else {
                token = PlaintextToken(char)
                currentToken = token
                return token
            }
        case let x where Scanner.isSpecialSymbol(x):
            token = SpecialSymbolToken(char)
            currentToken = token
            return token
        case let x where Scanner.isDigitCharacter(x):
            var skipped = skipDigits()
            if skipped.count > 0 {
                skipped.insert(char, atIndex: 0)
                guard let next = source.peekCharacter() else {
                    token = PlaintextToken(skipped)
                    currentToken = token
                    return token
                }
                if next == "." {
                    source.nextCharacter()
                    skipped.append(".")
                    token = OrderedListToken(skipped)
                    currentToken = token
                    return token
                } else {
                    token = PlaintextToken(skipped)
                    currentToken = token
                    return token
                }
            } else {
                token = PlaintextToken(char)
                currentToken = token
                return token
            }
        default:
            var text: [Character] = [char]
            while true {
                guard let next = source.peekCharacter() else {
                    break
                }
                if !Scanner.isSpecialSymbol(next) && !Scanner.isWhiteSpace(next) {
                    source.nextCharacter()
                    text.append(next)
                } else {
                    break
                }
            }
            token = PlaintextToken(text)
            currentToken = token
            return token
        }
    }

    public func peekToken() -> Token? {
        source.markPosition()
        isPeek = true
        let token = nextToken()
        isPeek = false
        source.applyPositionMarker()
        return token
    }

    func skipCharacters(characters: [Character], count: Int) -> [Character] {
        var skipped = [Character]()
        for _ in 0 ..< count {
            guard let char = source.peekCharacter()
            where characters.contains(char) else {
                break
            }
            skipped.append(source.nextCharacter()!)
        }
        return skipped
    }

    func skipDigits() -> [Character] {
        var skipped = [Character]()
        while true {
            guard let next = source.peekCharacter() else {
                break
            }
            if Scanner.isDigitCharacter(next) {
                source.nextCharacter()
                skipped.append(next)
            } else {
                break
            }
        }
        return skipped
    }

    func skipMostCharacters(characters: [Character]) -> [Character] {
        var skipped = [Character]()
        while true {
            guard let char = source.peekCharacter()
            where characters.contains(char) else {
                break
            }
            skipped.append(source.nextCharacter()!)
        }
        return skipped
    }

    static func isDigitCharacter(character: Character) -> Bool {
        return digitCharacterSet.contains(character)
    }

    static func isLowercaseLetter(character: Character) -> Bool {
        return lowercaseLetterCharacterSet.contains(character)
    }

    static func isUppercaseLetter(character: Character) -> Bool {
        return uppercaseLetterCharacterSet.contains(character)
    }

    static func isLetter(character: Character) -> Bool {
        return lowercaseLetterCharacterSet.contains(character)
        || uppercaseLetterCharacterSet.contains(character)
    }

    static func isSpecialSymbol(character: Character) -> Bool {
        return specialSymbolSet.contains(character)
    }

    static func isWhiteSpace(character: Character) -> Bool {
        return whiteSpaceSet.contains(character)
    }
}
