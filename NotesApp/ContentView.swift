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
            
            .sheet(isPresented: $isShowingSheet, onDismiss: { }) {
                List {
                    Section(header:
                        Text("Nova nota")
                    ) {
                        TextField("Título", text: $draft.title)
                        TextField("Lembrar...", text: $draft.content)
                        HStack {
                            Spacer()
                            Button(action: {
                                if draft.isFilled() {
                                    let newNote = Note(title: draft.title, content: draft.content)
                                    
                                    context.insert(newNote)
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

#Preview {
    ContentView()
}
