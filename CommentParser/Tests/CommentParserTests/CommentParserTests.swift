import XCTest
@testable import CommentParser
import SwiftSyntax
import SwiftSyntaxParser

final class CommentParserTests: XCTestCase {
    func testExample() throws {
        
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
        
    }
}
