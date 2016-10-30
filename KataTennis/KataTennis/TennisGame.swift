//
// Created by Kim SAVAROCHE on 30/10/16.
// Copyright (c) 2016 Kim SAVAROCHE. All rights reserved.
//

import Foundation

enum Player {
    case Player1
    case Player2
}

class TennisGame {
    enum Score {
        case Points(player1:Int, player2:Int)
        case Advantage(player:Player)
        case Win(player:Player)

        func increment(scorer:Player) -> Score {
            switch self {
            case let .Advantage(player) where scorer == player:
                return .Win(player: scorer)

            case let .Advantage(player) where scorer != player:
                return .Points(player1:40, player2:40)

            case .Points(40, 40):
                return .Advantage(player: scorer)

            case let .Points(score1, score2) where .Player1 == scorer:
                return .Points(player1: nextPoints(p: score1), player2: score2)

            case let .Points(score1, score2) where .Player2 == scorer:
                return .Points(player1: score1, player2: nextPoints(p: score2))

            default:
                return self
            }
        }

        func nextPoints(p:Int) -> Int {
            return p < 30 ? p+15 : 40
        }
    }

    func score(history:[Player]) -> Score {
        return history.reduce(.Points(player1:0, player2:0), { $0.increment(scorer: $1) } )
    }
}

extension TennisGame {
    func scoreString(name1:String, name2:String, history:[Player]) -> String {
        let nameOf = { $0 == Player.Player1 ? name1 : name2 }

        switch score(history: history) {
        case .Points(40, 40):
            return "Deuce"

        case let .Points(score1, score2) where score1 == score2 && score1 >= 15:
            return "\(score1) A"

        case let .Points(score1, score2):
            return "\(name1): \(score1) - \(name2): \(score2)"

        case let .Advantage(player):
            return "Advantage \(nameOf(player))"

        case let .Win(player):
            return "\(nameOf(player)) wins"
        }
    }
}
