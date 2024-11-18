//
//  ContentView.swift
//  NotesApp
//
//  Created by Lais Godinho on 11/11/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var context
    
    @State var draftManager = DraftManager.shared
    
    @State var draftTitle: String = DraftManager.shared.loadDraftTitle()
    
    @State var draftContent: String = DraftManager.shared.loadDraftContent()
    
    @Query var notes: [Note]
    
    @State private var isShowingSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(notes) { note in
                    VStack(alignment: .leading) {
                        Text(note.title)
                            .font(.title2)
                        Text(note.content)
                            .lineLimit(6)
                    }
                }
                .onDelete { offsets in
                    for index in offsets {
                        context.delete(notes[index])
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isShowingSheet = true
                    }) {
                        Text("Nova nota")
                    }
                }
            }
            .navigationTitle("Notas salvas")
            .sheet(isPresented: $isShowingSheet, onDismiss: { draftManager.saveDraftToFile(title: draftTitle, content: draftContent) }) {
                List {
                    Section(header:
                        Text("Nova nota")
                    ) {
                        TextField("Título", text: $draftTitle)
                            .onChange(of: draftTitle) { oldValue, newValue in
                                draftManager.saveDraftToFile(title: draftTitle, content: draftContent)
                            }
                        TextField("Lembrar...", text: $draftContent, axis: .vertical)
                            .onChange(of: draftContent) { oldValue, newValue in
                                draftManager.saveDraftToFile(title: draftTitle, content: draftContent)
                            }
                        HStack {
                            Spacer()
                            Button(action: {
                                if !draftTitle.isEmpty && !draftContent.isEmpty {
                                    let newNote = Note(title: draftTitle, content: draftContent)
                                    context.insert(newNote)
                                    draftTitle = ""
                                    draftContent = ""
                                    draftManager.clearDraft()
                                    isShowingSheet = false
                                }
                            }) {
                                Text("Salvar")
                            }
                        }
                    }
                }
            }
        }
    }
}

class DraftManager {
    
    public static var shared = DraftManager()
    
    private var draftFilePath: URL {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent("draft_note.json")
    }
    
    public func saveDraftToFile(title: String, content: String) {
        let draftData = ["title": title, "content": content]
        
        if let data = try? JSONEncoder().encode(draftData) {
            try? data.write(to: draftFilePath)
        }
    }
    
    public func loadDraftTitle() -> String {
        guard let data = try? Data(contentsOf: draftFilePath),
              let draftData = try? JSONDecoder().decode([String: String].self, from: data) else {
            return ""
        }
        
        return draftData["title"] ?? ""
    }
    
    public func loadDraftContent() -> String {
        guard let data = try? Data(contentsOf: draftFilePath),
              let draftData = try? JSONDecoder().decode([String: String].self, from: data) else {
            return ""
        }
        
        return draftData["content"] ?? ""
    }
    
    public func clearDraft() {
        try? FileManager.default.removeItem(at: draftFilePath)
    }
}
