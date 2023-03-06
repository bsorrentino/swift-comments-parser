import Foundation
import Combine

let FS = FileManager.default

FS.currentDirectoryPath

let currentPath = URL( string: "/Users/bsorrentino/WORKSPACES/GITHUB.me/AppleOS/" )

// let path = URL( string: "swift-comments-parser/SwiftCommentParser", relativeTo: currentPath )
let path = URL( string: "PlantUML4iPad", relativeTo: currentPath )


func walkDirectory(at url: URL, options: FileManager.DirectoryEnumerationOptions ) -> AsyncStream<URL> {
    AsyncStream { continuation in
        Task {
            let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: nil, options: options)
            
            while let fileURL = enumerator?.nextObject() as? URL {
                if fileURL.hasDirectoryPath {
                    for await item in walkDirectory(at: fileURL, options: options) {
                        continuation.yield(item)
                    }
                } else {
                    continuation.yield( fileURL )
                }
            }
            continuation.finish()
        }
    }
}

let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles, .skipsPackageDescendants]

Task {
    
    let swiftFiles = walkDirectory(at: path!, options: options).filter {
        $0.pathExtension == "swift"
    }
    for await item in swiftFiles {
        print(item.lastPathComponent)
    }
    
}




