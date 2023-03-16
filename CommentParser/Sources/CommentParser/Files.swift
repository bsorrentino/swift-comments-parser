//
//  files.swift
//  SwiftCommentParser
//
//  Created by Bartolomeo Sorrentino on 02/01/23.
//
// [Async sequences, streams, and Combine](https://www.swiftbysundell.com/articles/async-sequences-streams-and-combine/)

import Foundation
import Combine

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
