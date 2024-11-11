//
//  NewNote.swift
//  NotesApp
//
//  Created by Lais Godinho on 11/11/24.
//
//
//import SwiftUI
//
//struct NewNote: View {
//    
//    @Environment(\.modelContext) private var context
//    
//    @State var draft = NoteDraft()
//
//    var body: some View {
//        TextField("Título", text: $draft.title)
//        TextField("Lembrar...", text: $draft.content)
//        HStack {
//            Spacer()
//            Button(action: {
//                if draft.isFilled() {
//                    let newNote = Note(title: draft.title, content: draft.content)
//                    
//                    context.insert(newNote)
//                }
//            }) {
//                Text("Salvar")
//            }
//        }
//    }
//}
