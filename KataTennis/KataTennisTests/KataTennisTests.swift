//
//  KataTennisTests.swift
//  KataTennisTests
//
//  Created by Kim SAVAROCHE on 18/09/16.
//  Copyright © 2016 Kim SAVAROCHE. All rights reserved.
//

import XCTest
@testable import KataTennis

extension Int {
    func times(f:() -> ()) {
        for _ in 1...self {
            f()
        }
    }
}


class KataTennisTests: XCTestCase {
    let name1 = "player1"
    let name2 = "player2"
    var history:[Player]!
    var game:TennisGame!

    override func setUp() {
        game = TennisGame()
        history = [Player]()
    }
    func player1Scores() {
        history.append(.Player1)
    }

    func player2Scores() {
        history.append(.Player2)
    }

    func bothPlayerScores() {
        player1Scores()
        player2Scores()
    }

    func scoreDeuce() {
        3.times { self.player1Scores() }
        3.times { self.player2Scores() }
    }

    func nameOf(player:Player) -> String {
        return player == .Player1 ? name1 : name2
    }

    func scoreString() -> String {
        return game.scoreString(name1: name1, name2: name2, history:history)
    }

    func assertScore(player1 score1:Int, player2 score2:Int) {
        XCTAssertEqual(scoreString(), "\(name1): \(score1) - \(name2): \(score2)")
    }

    func assertTiedScore(score:Int) {
        XCTAssertEqual(scoreString(), "\(score) A")
    }

    func assertDeuceScore() {
        XCTAssertEqual(scoreString(), "Deuce")
    }

    func assertAdvantageScore(player:Player) {
        XCTAssertEqual(scoreString(), "Advantage \(nameOf(player: player))")
    }

    func assertWinningScore(player:Player) {
        XCTAssertEqual(scoreString(), "\(nameOf(player: player)) wins")
    }
}

class TennisGame_OnStart : KataTennisTests {
    func testInitialScore_BothPlayersHaveZero() {
        assertScore(player1: 0, player2:0)
    }

    func testPlayer1Scores_Gets15Points() {
        player1Scores()
        assertScore(player1: 15, player2:0)
    }

    func testBothPlayersScore_BothGets15Points() {
        bothPlayerScores()
        assertTiedScore(score: 15)
    }

    func testPlayer1ScoresTwice_Gets30Points() {
        2.times { self.player1Scores() }
        assertScore(player1: 30, player2: 0)
    }

    func testPlayer1Scores3Times_Gets40Points() {
        3.times { self.player1Scores() }
        assertScore(player1: 40, player2: 0)
    }
}

class TennisGame_AfterDeuce : KataTennisTests {
    override func setUp() {
        super.setUp()
        scoreDeuce()
    }

    func testScoreIsDeuce() {
        assertDeuceScore()
    }

    func testPlayer1Scores_HasAdvantage() {
        player1Scores()
        assertAdvantageScore(player: .Player1)
    }

    func testPlayer2Scores_HasAdvantage() {
        player2Scores()
        assertAdvantageScore(player: .Player2)
    }

    func testBothPlayersScore_BackToDeuce() {
        bothPlayerScores()
        assertDeuceScore()
    }

    func testPlayer1HasAdvantageAndScores_Wins() {
        2.times { self.player1Scores() }
        assertWinningScore(player: .Player1)
    }

    func testPlayer2HasAdvantageAndScores_Wins() {
        2.times { self.player2Scores() }
        assertWinningScore(player: .Player2)
    }
}
