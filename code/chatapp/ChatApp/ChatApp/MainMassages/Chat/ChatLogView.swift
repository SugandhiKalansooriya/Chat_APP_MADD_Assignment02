//
//  ChatLogView.swift
//  ChatApp
//
//  Created by Sugandhi Hansika Kalansooriya on 2023-04-26.
//

import SwiftUI
import Firebase
import FirebaseFirestore

import CoreLocationUI
import CoreLocation



class ChatLogViewModel: ObservableObject {
    
    @Published var chatText = ""
    @Published var errorMessage = ""
   

    @Published var chatMessages = [ChatMessage]()
    
    var chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    var firestoreListener: ListenerRegistration?
    

    
    func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        firestoreListener?.remove()
        chatMessages.removeAll()
        firestoreListener = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.messages)
            .document(fromId)
            .collection(toId)
            .order(by: FirebaseConstants.timestamp)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        if let chatMessageData = try? change.document.data(as: ChatMessage.self) {
                            self.chatMessages.append(chatMessageData)
                            print("Appending chatMessage in ChatLogView: \(Date())")
                        } else {
                            print("Failed to decode message")
                        }
                    }
                })
                
                DispatchQueue.main.async {
                    self.count += 1
                }
            }
    }

    
    func handleSend() {
        print(chatText)
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore.collection(FirebaseConstants.messages)
            .document(fromId)
            .collection(toId)
            .document()
        
        let msg = ChatMessage(id: nil, fromId: fromId, toId: toId, text: chatText, timestamp: Date())
        
        try? document.setData(from: msg) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Successfully saved current user sending message")
            
            self.persistRecentMessage()
            
            self.chatText = ""
            self.count += 1
        }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        try? recipientMessageDocument.setData(from: msg) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Recipient saved message as well")
        }
    }
    
    private func persistRecentMessage() {
        guard let chatUser = chatUser else { return }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = self.chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .document(toId)
        
        let data = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: chatUser.profileImageUrl,
            FirebaseConstants.email: chatUser.email
        ] as [String : Any]
        
        // you'll need to save another very similar dictionary for the recipient of this message...how?
        
        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                print("Failed to save recent message: \(error)")
                return
            }
        }
        
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        let recipientRecentMessageDictionary = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: currentUser.profileImageUrl,
            FirebaseConstants.email: currentUser.email
        ] as [String : Any]
        
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(toId)
            .collection(FirebaseConstants.messages)
            .document(currentUser.uid)
            .setData(recipientRecentMessageDictionary) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
    }
    
    @Published var count = 0
}

struct ChatLogView: View {
    
    @State private var isSheetPresented = false
    @ObservedObject var vm: ChatLogViewModel
    @State private var isShareLocationView: Bool = false
    @State var cordinate = CLLocationCoordinate2D()
    @State private var showMapView = false
    var body: some View {
        ZStack {
            messagesView
            Text(vm.errorMessage)
        }
        .navigationTitle(vm.chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
        
        .onDisappear {
            vm.firestoreListener?.remove()
        }
    }
    
    static let emptyScrollToString = "Empty"
    
    private var messagesView: some View {
        VStack {
            if #available(iOS 15.0, *) {
                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        VStack {
                            ForEach(vm.chatMessages) { message in
                                MessageView(message: message)
                            }
                            
                            HStack{ Spacer() }
                            .id(Self.emptyScrollToString)
                        }
                        .onReceive(vm.$count) { _ in
                            withAnimation(.easeOut(duration: 0.5)) {
                                scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                            }
                        }
                    }
                }
                .background(Color(.init(white: 0.95, alpha: 1)))
                .safeAreaInset(edge: .bottom) {
                    chatBottomBar
                        .background(Color(.systemBackground).ignoresSafeArea())
                }
            } else {
                
            }
        }
    }
    
    
    
    private var chatBottomBar: some View {
        return VStack {
            HStack(spacing: 16) {
                // Image and TextEditor
                ZStack {
                    DescriptionPlaceholder()
                    TextEditor(text: $vm.chatText)
                        .opacity(vm.chatText.isEmpty ? 0.5 : 1)

                }
                .frame(height: 40)
                Button(action: {
                    isSheetPresented.toggle()
                }, label: {
                    Image(systemName: "paperclip")
                    .foregroundColor(.orange)
                    .padding(.trailing, 10)
                })

                // Send button
                Button {
                    vm.handleSend()
                } label: {
                    Text("Send")
                        .foregroundColor(.black)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color("Green"))
                .cornerRadius(4)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            if isSheetPresented {
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 200)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .transition(.move(edge: .bottom))
                    .offset(y: UIScreen.main.bounds.height * 0.25)
                    .overlay(
                        HStack(spacing: 10) {
                            VStack(spacing: 5){
                                Button(action: {
                                    self.isShareLocationView = true
                                }, label: {
                                    Image("location-pin-svgrepo-com")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.gray)
                                        .cornerRadius(10)
                                })
                                .sheet(isPresented: $isShareLocationView) {
                                    ShareLocationView(isShareLocationView: $isShareLocationView)
                                }
                                .padding(20)
                                Text("Set Location")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.gray)
                            }
                            
                            .padding(20)
                            VStack(spacing: 5){
                                Button(action: {
                                    vm.chatText = UserDefaults.standard.value(forKey: "location") as! String
                                    vm.handleSend()
                                }, label: {
                                    Image("send-svgrepo-com")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.gray)
                                        .cornerRadius(10)
                                })
                                .padding(20)
                                Text("Send Location")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.gray)
                            }
                            
                            .padding(20)
                        }
                        .padding(10)
                        
                        
                    )
            }


           
        }
    }

}



struct MessageView: View {
    let message: ChatMessage

    var body: some View {
        VStack (alignment:.leading){
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                HStack {
                    Spacer()
                    HStack {
                        if let url = URL(string: message.text),
                           UIApplication.shared.canOpenURL(url) {
                            Link(destination: url) {
                                Text(message.text)
                                    .foregroundColor(.white)
                            }
                        } else {
                            Text(message.text)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color("Pink"))
                    .cornerRadius(8)
                }
            } else {
                HStack{
                    HStack {
                        if let url = URL(string: message.text),
                           UIApplication.shared.canOpenURL(url) {
                            Link(destination: url) {
                                Text(message.text)
                                    .foregroundColor(.black)
                            }
                        } else {
                            Text(message.text)
                                .foregroundColor(.black)
                        }


                    }

                    .padding()
                    .background(Color("Yellow"))
                    .cornerRadius(8)
                    Spacer()
                }

            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}


private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Description")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {

        MainMessagesView()
    }
}
