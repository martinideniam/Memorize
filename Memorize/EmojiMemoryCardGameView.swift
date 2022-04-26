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
        VStack {
            gameBody
            Spacer()
            shuffle
        }
            .padding()
    }
     
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
            if card.isMatched && !card.isFaceUp {
                Color.clear
            } else {
                CardView(card: card)
                    .padding(4)
                    .transition(AnyTransition.scale)
                    .onTapGesture {
                        withAnimation(Animation.easeInOut) {
                            game.choose(card)
                        }
                    }
            }
         })
    }
     
     var shuffle: some View {
         Button("Shuffle") {
             withAnimation(Animation.easeInOut(duration: 0.5)) {
                 game.shuffle()
             }
         }
     }
 }

struct CardView: View {
    let card: EmojiMemoryGame.Card
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 90-90), clockwise: false)
                    .foregroundColor(.red)
                    .opacity(0.4)
                    .padding(5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: card.isMatched)
                    .font(.system(size: DrawingConstants.fontSize))
                    .scaleEffect(fontScale(thatFitsSize: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        })
    }
    
    private func fontScale(thatFitsSize: CGSize) -> CGFloat {
        min(thatFitsSize.height, thatFitsSize.width) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private func returnFontSize (in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height)*DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale = 0.65
        static let fontSize: CGFloat = 32
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        return EmojiMemoryCardGameView(game: game)
    }
}
