//
//  CopyToClipboard.swift
//  CommentParserApp
//
//  Created by Bartolomeo Sorrentino on 06/03/23.
//

import SwiftUI
import OSLog


public struct CopyToClipboardButton : View {
    
    var value:String
    
    public init( value:String ) {
        self.value = value
    }
    public var body: some View {
        
        Button( action: {
            #if os(iOS)
            UIPasteboard.general.string = self.value
            #elseif os(macOS)
            NSPasteboard.general.declareTypes([ NSPasteboard.PasteboardType.string ], owner: nil)
            NSPasteboard.general.setString(self.value, forType: .string)
            #endif
            os_log( .debug, "copied to clipboard!")
        }, label: {
            Label( "copy", systemImage: "doc.on.clipboard")
                .padding( 10 )
                
        })
        .buttonStyle(ScaleButtonStyle())
        
        
    }
}

struct CopyToClipboard_Previews: PreviewProvider {
    static var previews: some View {
        CopyToClipboardButton( value: "test" )
    }
}
