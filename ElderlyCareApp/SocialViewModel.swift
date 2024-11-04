//
//  SocialViewModel.swift
//  ElderlyCareApp
//
//  Created by MOHAN KUMMARIGUNTA on 9/15/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Combine
import SwiftUI

struct Message: Identifiable, Codable {
    @DocumentID var id: String?
    var content: String
    var isUser: Bool
    var timestamp: Date
    var userId: String
}

class SocialViewModel: ObservableObject {
    @Published var messages: [Message] = []
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    // Fetch messages from Firestore
    func fetchMessages() {
        listener = db.collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let snapshot = snapshot {
                    self.messages = snapshot.documents.compactMap { doc in
                        try? doc.data(as: Message.self)
                    }
                }
            }
    }
    
    // Send a new message
    func sendMessage(content: String) {
        guard let user = Auth.auth().currentUser else { return }
        let message = Message(content: content, isUser: true, timestamp: Date(), userId: user.uid)
        do {
            _ = try db.collection("messages").addDocument(from: message)
        } catch {
            print("Error sending message: \(error)")
        }
    }
    
    // Upload a photo to Firebase Storage
    func uploadPhoto(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8),
              let user = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference().child("photos/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if error != nil {
                print("Error uploading photo: \(String(describing: error))")
                completion(nil)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let url = url {
                    completion(url)
                } else {
                    print("Error getting download URL: \(String(describing: error))")
                    completion(nil)
                }
            }
        }
    }
    
    deinit {
        listener?.remove()
    }
}
