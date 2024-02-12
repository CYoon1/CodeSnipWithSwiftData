//
//  SnippetEditView.swift
//  CodeSnipWithSwiftData
//
//  Created by Christopher Yoon on 2/12/24.
//

import SwiftUI
import SwiftData

@Model
class Snippet {
    var id = UUID()
    var name = ""
    var codeSnip = ""
    
    init(id: UUID = UUID(), name: String = "", codeSnip: String = "") {
        self.id = id
        self.name = name
        self.codeSnip = codeSnip
    }
}

struct SnippetEditView: View {
    @Bindable var snippet: Snippet
    var save: (Snippet) -> ()
    var delete: (Snippet) -> ()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Form {
                TextField("Snippet Name", text: $snippet.name)
                TextField("Snippet", text: $snippet.codeSnip)
            }
            
            HStack {
                Spacer()
                Button(role: .destructive) {
                    delete(snippet)
                    dismiss()
                } label: {
                    Text("Delete")
                }
                Spacer()
                Button(role: .none) {
                    save(snippet)
                    dismiss()
                } label: {
                    Text("Save")
                }
                Spacer()
            }.buttonStyle(.bordered)
        }
    }
}

#Preview {
    let example = Snippet(name: "Test", codeSnip: "print(\"hello world\")")
    return NavigationStack {
        SnippetEditView(snippet: example, save: { _ in }, delete: { _ in })
    }
    .modelContainer(for: Snippet.self, inMemory: true)
}
