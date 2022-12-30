//
//  main.swift
//  SwiftCommentParser
//
//  Created by Bartolomeo Sorrentino on 30/12/22.
//

import SwiftSyntax
import SwiftSyntaxParser

final class CommandVisitor: SyntaxVisitor {

    init() {
        super.init(viewMode: .sourceAccurate)
    }

    
    override func visitPost(_ node: TokenSyntax) {
        parseComments( node.leadingTrivia, prefix: "leading" )
        parseComments( node.trailingTrivia, prefix: "trailing" )
    }
}

extension CommandVisitor {
    
    func parseComments( _ trivia: Trivia, prefix: String) {
         for t in trivia {
             switch t {
             case .lineComment(let comment):
                 print( "\(prefix): line comment: \(comment)" )
             case .blockComment(let comment):
                 print( "\(prefix): block comment: \(comment)" )
             case .docLineComment(let comment):
                 print( "\(prefix): doc line comment: \(comment)" )
             case .docBlockComment(let comment):
                 print( "\(prefix): doc block comment: \(comment)" )
             default:
                 break
             }
         }
     }
}


let sourceText =
"""

/// test
func greeting(name: String) {
  print("Hello, \\(name)!")
}
"""

do {
    // Parse the source code in sourceText into a syntax tree
    let sourceFile: SourceFileSyntax = try SyntaxParser.parse(source: sourceText)
    
    // The "description" of the source tree is the source-accurate view of what was parsed.
    assert(sourceFile.description == sourceText)
    
    let visitor = CommandVisitor()
    
    visitor.walk(sourceFile)
    
    // Visualize the complete syntax tree.
    // dump(sourceFile)
    
} catch {
    print( "ERROR: \(error)")
}
