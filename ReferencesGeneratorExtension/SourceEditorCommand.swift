//
//  SourceEditorCommand.swift
//  ReferencesGeneratorExtension
//
//  Created by Bartolomeo Sorrentino on 03/03/23.
//

import Foundation
import XcodeKit
import OSLog
class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        os_log("Extension invoked", type: .debug)

        
        completionHandler(nil)
    }
    
}
