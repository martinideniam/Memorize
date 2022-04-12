//
//  EmojiMemoryCardGameView.swift
//  Memorize
//
//  Created by Vladislav Gorovenko on 21.01.2022.
// View

import SwiftUI

 struct EmojiMemoryCardGameView: View {
    
    @ObservedObject var  game: EmojiMemoryGame

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(game.cards) { card in
                    if !card.isMatched {
                        CardView(card: card).aspectRatio(2/2.5, contentMode: .fit)
                            .onTapGesture {
                                game.choose(card)
                            }
                    } else {
                        CardView(card: card).aspectRatio(2/2.5, contentMode: .fit)
                            .opacity(0)
                    }
                }
            }.padding(.top, 30)
        }
    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp {
                    shape.fill(Color.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    Text(card.content).font(returnFontSize(in: geometry.size))
                } else {
                    shape.fill(Color.pink)
                }
            }.padding(.all, 6)
        })
    }
    
    func returnFontSize (in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height)*DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius:CGFloat = 20
        static let fontScale = 0.6
        static let lineWidth:CGFloat = 3
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryCardGameView(game: game).preferredColorScheme(.light)
        EmojiMemoryCardGameView(game: game).preferredColorScheme(.dark)
    }
}
