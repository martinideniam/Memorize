//
//  Cardify.swift
//  Memorize
//
//  Created by Vladislav Gorovenko on 23.04.2022.
//

import SwiftUI

struct Cardify: AnimatableModifier {

    var isMatched: Bool
    var rotation: Double // degrees
    
    init(isFaceUp: Bool, isMatched: Bool) {
        self.isMatched = isMatched
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if rotation < 90 {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                } else {
                    shape
                        .fill()
                        .opacity(isMatched ? 0 : 1)
                }
                content
                    .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (x: 0, y: 1, z: 0))
    }
    
    private struct DrawingConstants {
        static let cornerRadius:CGFloat = 10
        static let fontScale = 0.65
        static let lineWidth:CGFloat = 3
    }
}


extension View {
    func cardify(isFaceUp: Bool, isMatched: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, isMatched: isMatched))
    }
}
