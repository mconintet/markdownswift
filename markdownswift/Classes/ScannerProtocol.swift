//
//  ScannerProtocol.swift
//  markdownswift
//
//  Created by mconintet on 4/21/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public protocol ScannerProtocol {
    func markPosition()
    func applyPositionMarker()
    func discardPositionMarker()
    func markedCharacters() -> [Character]?

    var previousToken: Token? { get }
    var currentToken: Token? { get }

    func beginCaptureToken()
    func endCaptureToken()
    func capturedTokens() -> [Token]?

    func nextToken() -> Token?
    func peekToken() -> Token?
}
