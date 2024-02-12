//
//  SnippetListView.swift
//  CodeSnipWithSwiftData
//
//  Created by Christopher Yoon on 2/12/24.
//

import SwiftUI
import SwiftData

struct SnippetListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var snippets: [Snippet]
    
    var body: some View {
        List {
            ForEach(snippets) { snippet in
                NavigationLink {
                    SnippetEditView(snippet: snippet, save: save, delete: delete)
                } label: {
                    Text(snippet.name)
                }
            }
        }
        .navigationTitle("Snippet List")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: SnippetEditView(snippet: Snippet(), save: add, delete: { _ in }) ) {
                    Label("Add", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Snippet.self, configurations: config)
    return NavigationStack {
        SnippetListView()
    }
    .modelContainer(container)
}


extension SnippetListView {
    private func save(_ snippet: Snippet) {
        withAnimation {
            try? self.modelContext.save()
        }
    }
    private func add(_ snippet: Snippet) {
        withAnimation {
            modelContext.insert(snippet)
        }
    }
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(snippets[index])
            }
        }
    }
    private func delete(snippet: Snippet) {
        withAnimation {
            modelContext.delete(snippet)
        }
    }
}
