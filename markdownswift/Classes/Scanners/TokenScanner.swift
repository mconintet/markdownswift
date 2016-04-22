
//
//  TokenScanner.swift
//  markdownswift
//
//  Created by mconintet on 4/21/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public class TokenScanner: ScannerProtocol {
    public let tokens: [Token]

    public private(set) var isPeek = false

    public private(set) var previousToken: Token? = nil

    public private(set) var position = -1

    public private(set) var positionStack = [Int]()

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

    public init(_ tokens: [Token]) {
        self.tokens = tokens
    }

    public func markPosition() {
        positionStack.append(position)
    }

    public func applyPositionMarker() {
        if let last = positionStack.popLast() {
            position = last
        }
    }

    public func discardPositionMarker() {
        positionStack.popLast()
    }

    public func markedCharacters() -> [Character]? {
        fatalError("Not Implemented")
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
        let next = position + 1
        if next < tokens.count {
            position = next
            let idx = tokens.startIndex.advancedBy(next)
            currentToken = tokens[idx]
            return currentToken
        }
        return nil
    }

    public func peekToken() -> Token? {
        let next = position + 1
        if next < tokens.count {
            let idx = tokens.startIndex.advancedBy(next)
            return tokens[idx]
        }
        return nil
    }
}
