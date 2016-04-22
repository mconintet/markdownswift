//
//  SourceProtocol.swift
//  markdownswift
//
//  Created by mconintet on 4/20/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public protocol SourceProtocol {
    var currentPosition: Int { get }
    var currentLineNumber: Int { get }

    func currentCharacter() -> Character?
    func nextCharacter() -> Character?
    func nextCharacters(count: Int) -> [Character]?
    func nextCharacters(delimiter: Character) -> [Character]?
    func nextLine() -> [Character]?
    func peekCharacter() -> Character?

    func markPosition()
    func applyPositionMarker()
    func discardPositionMarker()
    func markedCharacters() -> [Character]?

    func backPosition(count: Int)
}
