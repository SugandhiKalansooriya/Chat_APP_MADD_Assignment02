//
//  ChatMessage.swift
//  ChatApp
//
//  Created by Sugandhi Hansika Kalansooriya on 2023-04-26.
//


import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct ChatMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let fromId, toId, text: String
    let timestamp: Date
}
