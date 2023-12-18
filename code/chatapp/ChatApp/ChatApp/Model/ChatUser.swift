//
//  ChatUser.swift
//  ChatApp
//
//  Created by Sugandhi Hansika Kalansooriya on 2023-04-26.
//

import FirebaseFirestoreSwift

struct ChatUser: Codable, Identifiable {
    @DocumentID var id: String?
    let uid, email, profileImageUrl: String
}
