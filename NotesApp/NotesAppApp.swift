//
//  NotesAppApp.swift
//  NotesApp
//
//  Created by Lais Godinho on 11/11/24.
//

import SwiftUI
import SwiftData

@main
struct NotesAppApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Note.self])
        }
    }
}
