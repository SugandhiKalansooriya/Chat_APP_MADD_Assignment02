//
//  RecentMessage.swift
//  ChatApp
//
//  Created by Sugandhi Hansika Kalansooriya on 2023-04-27.
//


import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore


struct RecentMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let text, email: String
    let fromId, toId: String
    let profileImageUrl: String
    let timestamp: Date
    
    var username: String {
        email.components(separatedBy: "@").first ?? email
    }
    
    var timeAgo: String {

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.locale = Locale(identifier: "en_US")
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}
