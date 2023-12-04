//
//  ChessPuzzle.swift
//  Playboards
//
//  Created by kraujalis.rolandas on 30/11/2023.
//

import Foundation

struct ChessPuzzle: Codable {
    let puzzles: [Puzzle]
}

struct Puzzle: Codable {
    let puzzleID: String?
    let fen: String?
    let rating: Int?
    let moves: [String]?
}
