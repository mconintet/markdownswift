//
//  StringSource.swift
//  markdownswift
//
//  Created by mconintet on 4/20/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public class StringSource: SourceProtocol {
    let sourceString: String
    let sourceStringLength: Int

    public private(set) var currentPosition = -1
    public private(set) var currentLineNumber = -1

    private var positionMarkerStack = [Int]()

    public init(_ string: String) {
        sourceString = string
        sourceStringLength = sourceString.startIndex.distanceTo(string.endIndex)
    }

    public func currentCharacter() -> Character? {
        if currentPosition == -1 {
            return nil
        }
        let index = sourceString.startIndex.advancedBy(currentPosition)
        return sourceString[index]
    }

    public func nextCharacter() -> Character? {
        let next = currentPosition + 1
        if next == sourceStringLength {
            return nil
        }
        let index = sourceString.startIndex.advancedBy(next)
        currentPosition = next

        let char = sourceString[index]
        return char
    }

    public func nextCharacters(count: Int) -> [Character]? {
        var ret: [Character]?

        guard peekCharacter() != nil else {
            return ret
        }

        ret = [Character]()
        for _ in 0 ..< count {
            if let char = nextCharacter() {
                ret!.append(char)
            } else {
                break
            }
        }
        return ret
    }

    public func nextCharacters(delimiter: Character) -> [Character]? {
        var ret: [Character]?

        guard peekCharacter() != nil else {
            return ret
        }

        ret = [Character]()
        while true {
            if let char = nextCharacter() {
                ret!.append(char)
                if delimiter == char {
                    break
                }
            } else {
                break
            }
        }
        return ret
    }

    // does not include the line end ("\r" or "\r\n" or "\n")
    public func nextLine() -> [Character]? {
        var ret: [Character]?

        guard peekCharacter() != nil else {
            return ret
        }

        ret = [Character]()
        while true {
            guard let char = nextCharacter() else {
                break
            }
            if char == "\n" {
                break
            } else if char == "\r" {
                if let next = peekCharacter() {
                    if next == "\n" {
                        nextCharacter()
                    }
                }
                break
            } else {
                ret!.append(char)
            }
        }
        return ret
    }

    public func peekCharacter() -> Character? {
        let next = currentPosition + 1
        if next == sourceStringLength {
            return nil
        }
        let index = sourceString.startIndex.advancedBy(next)
        return sourceString[index]
    }

    public func markPosition() {
        positionMarkerStack.append(currentPosition)
    }

    public func discardPositionMarker() {
        positionMarkerStack.popLast()
    }

    public func markedCharacters() -> [Character]? {
        if let mark = positionMarkerStack.last {
            let start = sourceString.startIndex.advancedBy(mark)
            let end = sourceString.startIndex.advancedBy(currentPosition)
            return sourceString.substringWithRange(start ... end).toCharacters()
        }
        return nil
    }

    public func applyPositionMarker() {
        if let positionMarker = positionMarkerStack.last {
            currentPosition = positionMarker
            discardPositionMarker()
            return
        }
    }

    public func backPosition(count: Int) {
        if currentPosition == -1 {
            return
        }
        var back = currentPosition - count
        back = back < -1 ? -1 : back
        currentPosition = back
    }
}
