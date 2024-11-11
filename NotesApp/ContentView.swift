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
    
    @State var draft = NoteDraft()
    
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
            .sheet(isPresented: $isShowingSheet, onDismiss: { saveDraftToUserDefaults() }) {
                List {
                    Section(header:
                        Text("Nova nota")
                    ) {
                        TextField("Título", text: $draft.title)
                            .onChange(of: draft.title) {
                                saveDraftToUserDefaults()
                            }
                        TextField("Lembrar...", text: $draft.content, axis: .vertical)
                            .onChange(of: draft.content) {
                            saveDraftToUserDefaults()
                        }
                        HStack {
                            Spacer()
                            Button(action: {
                                if draft.isFilled() {
                                    let newNote = Note(title: draft.title, content: draft.content)
                                    context.insert(newNote)
                                    clearDraft()
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
    
    private func saveDraftToUserDefaults() {
        UserDefaults.standard.set(draft.title, forKey: "draftTitle")
        UserDefaults.standard.set(draft.content, forKey: "draftContent")
    }
    
    private func loadDraftFromUserDefaults() {
        draft.title = UserDefaults.standard.string(forKey: "draftTitle") ?? ""
        draft.content = UserDefaults.standard.string(forKey: "draftContent") ?? ""
    }
    
    private func clearDraft() {
        draft = NoteDraft()
        UserDefaults.standard.removeObject(forKey: "draftTitle")
        UserDefaults.standard.removeObject(forKey: "draftContent")
    }
}
