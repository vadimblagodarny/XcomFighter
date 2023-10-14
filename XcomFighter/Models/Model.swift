//
//  Model.swift
//  XcomFighter
//
//  Created by Vadim Blagodarny on 22.09.2023.
//

struct Player: Codable {
    let date: String
    let name: String
    let score: Int
}

struct HighScore: Codable {
    var players: [Player]?
}

struct Settings {
    let parameterName: String
    let parameterValue: Bool
}
