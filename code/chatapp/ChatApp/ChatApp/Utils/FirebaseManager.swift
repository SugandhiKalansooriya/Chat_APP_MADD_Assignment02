//
//  FirebaseManager.swift
//  ChatApp
//
//  Created by Sugandhi Hansika Kalansooriya on 2023-04-26.
//


import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

import Foundation


class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    var currentUser: ChatUser?
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
    
}
