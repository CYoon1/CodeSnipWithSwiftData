//
//  ContainerView.swift
//  CodeSnipWithSwiftData
//
//  Created by Christopher Yoon on 2/13/24.
//

import SwiftUI

struct ContainerView: View {
    
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink {
                    SnippetListView()
                } label: {
                    Text("Snippets")
                }
                NavigationLink {
                    TagListView()
                } label: {
                    Text("Tags")
                }
            }
        } content: {
            Text("Content")
        } detail: {
            Text("Detail")
        }

    }
}

#Preview {
    ContainerView()
}
