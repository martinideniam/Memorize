//
//  EmojiMemoryCardGameView.swift
//  Memorize
//
//  Created by Vladislav Gorovenko on 21.01.2022.
// View

import SwiftUI

 struct EmojiMemoryCardGameView: View {
    
    @ObservedObject var game: EmojiMemoryGame
    @Namespace private var dealingNamespace
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                    newGameButton
                    Spacer()
                    shuffle
                }
                .padding()
            }
            deckBoard
        }
            .padding()
    }
     
     @State private var dealt = Set<Int>()
     
     private func deal(_ card: EmojiMemoryGame.Card) {
         dealt.insert(card.id)
     }
     
     private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
         return !dealt.contains(card.id)
     }
     
     private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
         var delay = 0.0
         if let index = game.cards.firstIndex(where: {$0.id == card.id}) {
             delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
         }
         return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
     }
     
     private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
         -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
     }
     
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation(Animation.easeInOut) {
                            game.choose(card)
                        }
                    }
            }
         })
    }
     
     var deckBoard: some View {
         ZStack {
             ForEach(game.cards.filter{ isUndealt($0) }) { card in
                 CardView(card: card)
                     .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                     .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                     .zIndex(zIndex(of: card))
             }
         }
         .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
         .foregroundColor(CardConstants.color)
         .onTapGesture {
             for card in game.cards {
                 withAnimation(dealAnimation(for: card)) {
                     deal(card)
                 }
             }
         }
         .foregroundColor(CardConstants.color)
     }
     
    var shuffle: some View {
         Button("Shuffle") {
             withAnimation(Animation.easeInOut(duration: 0.5)) {
                 game.shuffle()
             }
         }
     }
     
     var newGameButton: some View {
         Button("New Game") {
             withAnimation {
                 game.createNewGame()
                 dealt.removeAll()
             }
         }
     }
     
     private struct CardConstants {
         static let color = Color.black
         static let aspectRatio: CGFloat = 2/3
         static let dealDuration: Double = 0.5
         static let totalDealDuration: Double = 2
         static let undealtHeight: CGFloat = 90
         static let undealtWidth = undealtHeight * aspectRatio
     }
 }

struct CardView: View {
    let card: EmojiMemoryGame.Card
    @State private var animatedBonusRemaining: Double = 0
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90), clockwise: false)
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90), clockwise: false)
                    }
                }
                    .opacity(0.4)
                    .padding(5)
                    .foregroundColor(.red)
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
