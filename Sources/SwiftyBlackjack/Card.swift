//
//  Trumps.swift
//  TCABlackJack
//
//  Created by 松本幸太郎 on 2023/06/21.
//
public struct Card{
    public let face:Face
    public var isFaceUp:Bool

    public init(face: Face, isFaceUp: Bool = true){
        self.face = face
        self.isFaceUp = isFaceUp
    }
}

extension Card{
    public mutating func putFaceUp(){ self = faceUp }
    public var faceUp: Card{ .init(face: face, isFaceUp: true) }
    public mutating func putFaceDown(){ self = faceDown }
    public var faceDown: Card{ .init(face: face, isFaceUp: false) }
}

extension Card:Identifiable{
    public var id:String{ face.suit.rawValue + face.rank.rawValue }
}

extension Card{
    public struct Face{
        public let rank:Rank
        public let suit:Suit
        public init(rank: Rank, suit: Suit) {
            self.rank = rank
            self.suit = suit
        }
    }

    public enum Rank:String,CaseIterable{
        case ace = "A"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case ten = "10"
        case jack = "J"
        case queen = "Q"
        case king = "K"
    }

    public enum Suit:String, CaseIterable{
        case heart = "❤︎"
        case clover = "♣︎"
        case diamond = "◆"
        case spade = "♠︎"
    }
}

