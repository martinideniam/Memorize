//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Vladislav Gorovenko on 21.01.2022.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame() // even though it is a let, it will reflect changes, because now it just works as a pointer
    var body: some Scene {
        WindowGroup {
            EmojiMemoryCardGameView(game: game)
        }
    }
}
