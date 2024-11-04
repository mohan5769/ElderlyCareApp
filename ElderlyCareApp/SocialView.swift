//
//  SocialView.swift
//  ElderlyCareApp
//
//  Created by MOHAN KUMMARIGUNTA on 9/15/24.
//

import SwiftUI
import FirebaseAuth

struct SocialView: View {
    @StateObject private var viewModel = SocialViewModel()
    @State private var newMessage: String = ""
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.messages) { message in
                    HStack {
                        if message.isUser {
                            Spacer()
                            if let url = URL(string: message.content),
                               message.content.hasSuffix(".jpg") || message.content.hasSuffix(".png") {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 150, height: 150)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(10)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 150, height: 150)
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else {
                                Text(message.content)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        } else {
                            if let url = URL(string: message.content),
                               message.content.hasSuffix(".jpg") || message.content.hasSuffix(".png") {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 150, height: 150)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(10)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 150, height: 150)
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else {
                                Text(message.content)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                Spacer()
                            }
                        }
                    }
                }

                
                HStack {
                    TextField("Enter message", text: $newMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        sendMessage()
                    }) {
                        Text("Send")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(newMessage.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()
                
                Button(action: {
                    showingImagePicker = true
                }) {
                    Text("Share Photo")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.bottom)
                .sheet(isPresented: $showingImagePicker, onDismiss: {
                    if let image = selectedImage {
                        uploadPhoto(image: image)
                    }
                }) {
                    ImagePicker(image: $selectedImage)
                }
            }
            .navigationTitle("Social")
            .onAppear {
                // Ensure the user is authenticated
                if Auth.auth().currentUser == nil {
                    Auth.auth().signInAnonymously { authResult, error in
                        if let error = error {
                            print("Error signing in anonymously: \(error)")
                        } else {
                            print("Signed in with UID: \(authResult?.user.uid ?? "No UID")")
                        }
                    }
                }
                
                viewModel.fetchMessages()
            }
        }
    }
    
    func sendMessage() {
        viewModel.sendMessage(content: newMessage)
        newMessage = ""
    }
    
    func uploadPhoto(image: UIImage) {
        viewModel.uploadPhoto(image: image) { url in
            if let url = url {
                let photoMessage = Message(content: url.absoluteString, isUser: true, timestamp: Date(), userId: Auth.auth().currentUser?.uid ?? "unknown")
                do {
                    try viewModel.db.collection("messages").addDocument(from: photoMessage)
                } catch {
                    print("Error sending photo message: \(error)")
                }
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView()
    }
}
