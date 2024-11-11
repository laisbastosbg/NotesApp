//
//  Note.swift
//  NotesApp
//
//  Created by Lais Godinho on 11/11/24.
//

import Foundation
import SwiftData

protocol NoteProtocol {
    var id: UUID { get set }
    
    var title: String { get set }
    
    var content: String { get set }
}

@Model
class Note: NoteProtocol {
    
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

class NoteDraft: NoteProtocol {
    var id: UUID
    
    var title: String
    
    var content: String
    
    init(title: String = "", content: String = "") {
        self.id = UUID()
        self.title = title
        self.content = content
    }
    
    func isFilled() -> Bool {
        return !(title.isEmpty || content.isEmpty)
    }
}
