//
//  Note.swift
//  NotesApp
//
//  Created by Lais Godinho on 11/11/24.
//

import Foundation
import SwiftData

@Model
class Note {
    
    public var id: UUID
    
    public var title: String
    
    public var content: String
    
    public var dateOfCreation: Date
    
    init(title: String, content: String) {
        id = UUID()
        self.title = title
        self.content = content
        self.dateOfCreation = Date()
    }
}

