//
//  Parser.swift
//  markdownswift
//
//  Created by mconintet on 4/20/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public class Parser {
    public let scanner: ScannerProtocol

    public init(_ scanner: ScannerProtocol) {
        self.scanner = scanner
    }

    public func nextToken() -> Token? {
        return scanner.nextToken()
    }

    public func peekToken() -> Token? {
        return scanner.peekToken()
    }

    public func currentToken() -> Token? {
        return scanner.currentToken
    }

    public func previousToken() -> Token? {
        return scanner.previousToken
    }

    public func markPosition() {
        scanner.markPosition()
    }

    public func applyPositionMarker() {
        scanner.applyPositionMarker()
    }

    public func discardPositionMarker() {
        scanner.discardPositionMarker()
    }

    public func beginCaptureToken() {
        scanner.beginCaptureToken()
    }

    public func endCaptureToken() {
        return scanner.endCaptureToken()
    }

    public func capturedTokens() -> [Token]? {
        return scanner.capturedTokens()
    }

    public func parse(token: Token? = nil) -> [CodeNode]? {
        fatalError("Not Implemented")
    }

    public func skipMostNewline() {
        while true {
            guard let next = peekToken() else {
                break
            }
            if next.type == .Newline {
                nextToken()
            } else {
                break
            }
        }
    }
}
