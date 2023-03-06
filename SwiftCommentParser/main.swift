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

final class CommandVisitor: SyntaxVisitor {

    private(set) var references = Set<String>()
    
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
             case .lineComment(let comment), .docLineComment(let comment):
                 references.insert(comment)
                 break
             case .blockComment(let comment), .docBlockComment(let comment):
                 references.insert(comment)
                 break
             default:
                 break
             }
         }
     }
}


let currentPath = URL( string: "/Users/bsorrentino/WORKSPACES/GITHUB.me/AppleOS/" )

let path = URL( string: "PlantUML4iPad", relativeTo: currentPath )

let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles, .skipsPackageDescendants]

let op = Task  {
    
    let visitor = CommandVisitor()

    let swiftFiles = walkDirectory(at: path!, options: options).filter {
        $0.pathExtension == "swift"
    }
    
    for await fileUrl in swiftFiles {
        do {
            
            let fileContents = try String(contentsOf: fileUrl, encoding: .utf8)
            
            // Parse the source code in sourceText into a syntax tree
            let sourceFile: SourceFileSyntax = try SyntaxParser.parse(source: fileContents)

            // The "description" of the source tree is the source-accurate view of what was parsed.
            assert(sourceFile.description == fileContents)

            visitor.walk(sourceFile)

            // Visualize the complete syntax tree.
            // dump(sourceFile)
            
        } catch {
            print( "ERROR: \(error)")
        }
    }
    
    return visitor.references
}

let result = await op.result

if let comments = try? result.get() {

    
    comments
        .reduce( into: [String: String]() ) { (dict, item ) in
            if let match = item.firstMatch(of: regexComment ) {
                dict[ String(match.2)] = String(match.1)
            }
        }
        .forEach {
            print( $0.value )
        }

}
/*
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
*/
