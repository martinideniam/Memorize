//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Vladislav Gorovenko on 18.03.2022.
// ViewModel

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    private static let emojis = ["🚗","🚕","🚙","🚎","🏎","🚓", "🚑","🚒","🚐","🛻","🚚","🚛","🚜"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 5, createCardContent: { (index: Int) -> String in
            emojis[index]
        })
    }
    
    @Published private(set) var model = createMemoryGame()
    
    var cards: Array<Card> {
        return model.cards
    }
    
    //MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
}
