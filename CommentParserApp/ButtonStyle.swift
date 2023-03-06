//
//  ButtonStyle.swift
//  CommentParserApp
//
//  Created by Bartolomeo Sorrentino on 06/03/23.
//

import Foundation
import SwiftUI

// [Advanced SwiftUI button styling and animation](https://www.simpleswiftguide.com/advanced-swiftui-button-styling-and-animation/)
struct ScaleButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var scale = 1.1
    
    func makeBody(configuration: Self.Configuration) -> some View {
        let color = colorScheme == .dark ? Color.white : Color.black
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .foregroundColor(color)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(color, lineWidth: 1) )
    }
}
