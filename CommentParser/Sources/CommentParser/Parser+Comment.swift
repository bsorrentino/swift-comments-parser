import Foundation
import Combine
import SwiftSyntax
import SwiftSyntaxParser

final class CommandVisitor: SyntaxVisitor, ObservableObject {

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
             case   .lineComment(let comment),
                     .docLineComment(let comment),
                     .blockComment(let comment),
                     .docBlockComment(let comment):
                 if let match = comment.firstMatch(of: regexComment ) {
                     references.insert(String(match.1))
                 }
                 break
             default:
                 break
             }
         }
     }
}


public func parseComment( at path: URL?  ) async -> Set<String> {
    guard let path else { return [] }
    
    let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles, .skipsPackageDescendants]
    
    let swiftFiles = walkDirectory(at: path, options: options).filter {
        $0.pathExtension == "swift"
    }

    let visitor = CommandVisitor()

    for await fileUrl in swiftFiles {
        do {
            
            try parse( fileUrl: fileUrl, visitor: visitor )
            
        } catch {
            print( "ERROR: \(error)")
        }
    }
       
    return visitor.references
}


func parse( fileUrl: URL, visitor: CommandVisitor ) throws {
    
    let fileContents = try String(contentsOf: fileUrl, encoding: .utf8)
    
    // Parse the source code in sourceText into a syntax tree
    let sourceFile: SourceFileSyntax = try SyntaxParser.parse(source: fileContents)
    
    // The "description" of the source tree is the source-accurate view of what was parsed.
    assert(sourceFile.description == fileContents)
    
    visitor.walk(sourceFile)
    
    // Visualize the complete syntax tree.
    // dump(sourceFile)
}
