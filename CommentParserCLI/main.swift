//
//  main.swift
//  SwiftCommentParser
//
//  Created by Bartolomeo Sorrentino on 30/12/22.
//

import Foundation
import Combine
import SwiftSyntax
import SwiftSyntaxParser
import CommentParser

let args = CommandLine.arguments.dropFirst()

let _ = await withTaskGroup( of: Void.self ) { group in
    for arg in args {
        
        let path = URL( string: NSString(string: arg).expandingTildeInPath )
        group.addTask {
            
            let result = await parseComment(at: path )
            print( "> \(arg) <\n")
            result.forEach {  print( "* \($0)") }
            print( String.init( repeating: "-", count: 80 ) )
        }
    }
}

