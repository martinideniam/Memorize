//
//  EmojiMemoryCardGameView.swift
//  Memorize
//
//  Created by Vladislav Gorovenko on 21.01.2022.
// View

import SwiftUI

 struct EmojiMemoryCardGameView: View {
    
    @ObservedObject var game: EmojiMemoryGame

    var body: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
            if !card.isMatched {
                CardView(card: card)
                    .padding(4)
                    .onTapGesture {
                        game.choose(card)
                }
            } else {
                CardView(card: card)
                    .opacity(0)
            }
        })
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
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 90-90), clockwise: false)
                            .foregroundColor(.red)
                            .opacity(0.4)
                            .padding(5)
                        Text(card.content).font(returnFontSize(in: geometry.size))
                    } else {
                        shape.fill(Color.pink)
                    }
            }
        })
    }
    
    func returnFontSize (in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height)*DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius:CGFloat = 10
        static let fontScale = 0.65
        static let lineWidth:CGFloat = 3
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryCardGameView(game: game)
    }
}
