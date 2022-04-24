//
//  Cardify.swift
//  Memorize
//
//  Created by Vladislav Gorovenko on 23.04.2022.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    var isMatched: Bool
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if isFaceUp  {
                    shape.fill(Color.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    content
                } else if isMatched{
                    shape.fill(Color.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    content
                        .opacity(0.4)
                }
                else {
                    shape.fill(Color.pink)
                }
        }
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
