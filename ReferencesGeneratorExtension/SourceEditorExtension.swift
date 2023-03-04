//
//  SourceEditorExtension.swift
//  ReferencesGeneratorExtension
//
//  Created by Bartolomeo Sorrentino on 03/03/23.
//

import Foundation
import XcodeKit
import OSLog

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    

    func extensionDidFinishLaunching() {
        // If your extension needs to do any work at launch, implement this optional method.
        os_log("Extension ready", type: .debug)
    }
    
    
    /*
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
        // If your extension needs to return a collection of command definitions that differs from those in its Info.plist, implement this optional property getter.
        return []
    }
    */
    
}
