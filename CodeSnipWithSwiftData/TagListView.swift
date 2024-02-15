//
//  TagListView.swift
//  CodeSnipWithSwiftData
//
//  Created by Christopher Yoon on 2/13/24.
//

import SwiftUI
import SwiftData

@Model
class Tag {
    var id = UUID()
    var name = ""
    @Relationship(inverse: \Snippet.tags) var snippets : [Snippet]
    
    init(id: UUID = UUID(), name: String = "", snippets: [Snippet] = []) {
        self.id = id
        self.name = name
        self.snippets = snippets
    }
}

struct TagEditView: View {
    @Bindable var tag: Tag
    var save: (Tag) -> ()
    var delete: (Tag) -> ()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Name", text: $tag.name)
                        .disableAutocorrection(true)
                } header: {
                    Text("Tag Name")
                }
            }
            HStack {
                Spacer()
                Button(role: .destructive) {
                    delete(tag)
                    dismiss()
                } label: {
                    Text("Delete")
                }
                Spacer()
                Button(role: .none) {
                    save(tag)
                    dismiss()
                } label: {
                    Text("Save")
                }
                Spacer()
            }.buttonStyle(.bordered)
        }
    }
}

struct TagListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tags: [Tag]
    
    var body: some View {
        List {
            ForEach(tags) { tag in
                NavigationLink {
                    TagEditView(tag: tag, save: save, delete: delete)
                } label: {
                    Text(tag.name)
                }
            }
        }
        .navigationTitle("Tag List")
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    TagEditView(tag: Tag(), save: add, delete: { _ in })
                } label: {
                    Label("Add", systemImage: "plus")
                }

            }
        })
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Tag.self, configurations: config)
    return NavigationStack {
        TagListView()
    }
    .modelContainer(container)
}

extension TagListView {
    private func save(_ tag: Tag) {
        withAnimation {
            try? self.modelContext.save()
        }
    }
    private func add(_ tag: Tag) {
        withAnimation {
            modelContext.insert(tag)
        }
    }
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(tags[index])
            }
        }
    }
    private func delete(tag: Tag) {
        withAnimation {
            modelContext.delete(tag)
        }
    }
}
