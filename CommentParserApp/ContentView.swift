//
//  ContentView.swift
//  CommentParserApp
//
//  Created by Bartolomeo Sorrentino on 04/03/23.
//

import SwiftUI
import CommentParser

// [Open a FileDialog in SwiftUI on MacOs](https://stackoverflow.com/a/63764764/521197)
struct ContentView: View {
    @State var fileUrl:URL?
    @State var showFileChooser = false
    @State var comments = Array<String>()
    @State var progressMessage:String?
    
    private func openFolderChoosePanel() {
        let panel = NSOpenPanel()
        
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.isAccessoryViewDisclosed = true
        panel.allowsMultipleSelection = false
        panel.resolvesAliases = true
        
        if panel.runModal() == .OK {
            self.fileUrl = panel.url
           
            processComments()
        }

    }
    
    private func processComments() {
        guard let fileUrl else { return }
        
        progressMessage = "parsing ..."
        
        Task {
            let result = await parseComment(at: fileUrl  )
            
            comments = result.map( { "* \($0)" } )
            
            progressMessage = nil

        }
        
    }
    
    private var isParsing:Bool {
        progressMessage != nil
    }
    
    var body: some View {
        VStack {
            Text( fileUrl?.relativeString ?? "" )
            Divider()

            if comments.isEmpty {
                Text( progressMessage ?? "no result")
                    .padding()
            }
            else {
                List( comments, id: \.self ) { comment in
                    Text( comment )
                        .font(.system(size: 12))
                        .monospaced()
                        .padding(0)
                }
            }
            Divider()
            HStack {
                if !isParsing {
                    Button( action: {
                        openFolderChoosePanel()
                    },
                            label: {
                        Label("select project folder", systemImage: "")
                            .labelStyle(.titleOnly)
                            .padding( 10 )
                    })
                    .buttonStyle(ScaleButtonStyle())
                }
                if !comments.isEmpty {
                    CopyToClipboardButton( value: comments.joined( separator: "\n") )
                }
                if fileUrl != nil && progressMessage == nil {
                    Button( action: {
                        processComments()
                    },
                    label: {
                        Label("process again", systemImage: "")
                            .labelStyle(.titleOnly)
                            .padding( 10 )
                    })
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
