//
//  Game.swift
//  TCABlackJack
//
//  Created by 松本幸太郎 on 2023/06/21.
//

public struct Blackjack {
    public private(set) var talon:[Card] //山札
    public private(set) var dealer: Dealer
    public private(set) var players: [Player]

    //MARK: init()
    public init(talon: [Card]? = nil, numberOfPlayers: Int = 1){
        let deck:[Card] =  {
            var cards:[Card] = []
            for suit in Card.Suit.allCases{
                for rank in Card.Rank.allCases{
                    let card = Card(face: Card.Face(rank: rank, suit: suit) )
                    cards.append(card)
                }
            }
            return cards
        }()

        let players:[Player] = {
            var players:[Player] = []
            for index in 0 ..< numberOfPlayers{
                players.append(Player(name: "Player \(index)") )
            }
            return players
        }()

        self.talon = talon ?? deck.shuffled()
        self.dealer = Dealer()
        self.players = players
    }
}

//MARK: input interface

extension Blackjack{
    mutating public func dealCard(toPlayerIndexOf index: Int){
        self.players[index].hand.append( drawFromTalon() )
    }
    mutating public func dealCardToDealer(isFaceUp: Bool = true){
        self.dealer.hand.append( drawFromTalon(isFaceUp: isFaceUp) )
    }
    mutating public func flipDealersSecondCard(){
        self.dealer.hand[1].putFaceUp()
    }
    mutating private func drawFromTalon(isFaceUp: Bool = true)->Card{
            guard let card = self.talon.first else {
                preconditionFailure("Game: Table talon nil")
            }
            self.talon.removeFirst()
        if isFaceUp{
            return card.faceUp
        }else{
            return card.faceDown
        }
    }
}

//MARK: Definition of Types. Dealer/Player/GameResult

extension Blackjack{
    public struct Dealer{
        public var hand:[Card]
        public var points:Int{ hand.map{ Blackjack.point(of: $0 ) }.reduce(0, +) }
        public var isBust:Bool{ points > 21 }
        public var hasFlippedSecondCard:Bool{
            if hand.count >= 2 {
               return hand[1].isFaceUp
            }else{
                return false
            }
        }
        public var needsToDrawToItself:Bool{ points < 17 }
        public mutating func addToHands(_ card: Card) { self.hand.append(card) }

        public init(hand:[Card] = []) { self.hand = hand }
    }

    public struct Player{
        public let name:String
        public var hand:[Card]
        public var points:Int{ hand.map{ Blackjack.point(of: $0 ) }.reduce(0, +) }
        public var isBust:Bool{ points > 21 }
        public mutating func addToHands(_ card: Card) { self.hand.append(card) }

        public init(name:String, hand:[Card] = []) {
            self.name = name
            self.hand = hand
        }
        public func getResult(ofGameWith dealer: Dealer)->GameResult{
            if dealer.isBust && self.isBust{
                return .draw
            }else if dealer.isBust{
                return .win
            }else if self.isBust{
                return .lose
            }else{
                let dealerGapFrom21 = 21 - dealer.points
                let playerGapFrom21 = 21 - self.points
                if dealerGapFrom21 == playerGapFrom21{
                    return .draw
                }else if dealerGapFrom21 > playerGapFrom21{
                    return .win
                }else{
                    return .lose
                }
            }
        }
    }

    public enum GameResult: String{
        case win = "win"
        case lose = "lose"
        case draw = "draw"
    }
}

//MARK: point

extension Blackjack{
    ///この点数はカードの本質ではなくゲームルールなのでcardではなくこちらで定義
    static func point(of card:Card)->Int{
        switch card.face.rank{
        case .ace:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        case .four:
            return 4
        case .five:
            return 5
        case .six:
            return 6
        case .seven:
            return 7
        case .eight:
            return 8
        case .nine:
            return 9
        case .ten:
            return 10
        case .jack:
            return 10
        case .queen:
            return 10
        case .king:
            return 10
        }
    }

}
