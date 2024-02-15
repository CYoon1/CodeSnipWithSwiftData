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
    var tags: [Tag]
    
    init(id: UUID = UUID(), name: String = "", codeSnip: String = "", tags: [Tag] = []) {
        self.id = id
        self.name = name
        self.codeSnip = codeSnip
        self.tags = tags
    }
}

struct SnippetEditView: View {
    @Bindable var snippet: Snippet
    var save: (Snippet) -> ()
    var delete: (Snippet) -> ()
    @Environment(\.dismiss) var dismiss
    @Query private var tags: [Tag]
    @State private var selectedTag: Tag?
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Snippet Name", text: $snippet.name)
                        .disableAutocorrection(true)
                } header: {
                    Text("Name")
                }
                Section {
                    HStack {
                        Picker("Add a Tag", selection: $selectedTag) {
                            Text("-")
                                .tag(nil as Tag?)
                            ForEach(tags) { tag in
                                Text(tag.name)
                                    .tag(tag as Tag?)
                            }
                        }
                        Button {
                            if let tag = selectedTag {
                                print("Adding Tag")
                                addTag(tag)
                                selectedTag = nil
                            }
                        } label: {
                            Text("Add Tag")
                        }
                    }
                    ForEach(snippet.tags) { tag in
                        Text(tag.name)
                            .onTapGesture {
                                removeTag(tag)
                            }
                    }
                } header: {
                    Text("Tags")
                }
                Section {
                    TextField("Snippet", text: $snippet.codeSnip, axis: .vertical)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                } header: {
                    Text("Code Snippet")
                }
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

extension SnippetEditView {
    private func addTag(_ tag: Tag) {
        print("Attempting Add Tag")
        snippet.tags.append(tag)
    }
    private func removeTag(_ tag: Tag) {
        if let index = snippet.tags.firstIndex(of: tag) {
            snippet.tags.remove(at: index)
        }
//        snippet.tags.delete(tag)
    }
}

#Preview {
    let example = Snippet(name: "Test", codeSnip: "print(\"hello world\")", tags: [])
    return NavigationStack {
        SnippetEditView(snippet: example, save: { _ in }, delete: { _ in })
    }
    .modelContainer(for: Snippet.self, inMemory: true)
}
