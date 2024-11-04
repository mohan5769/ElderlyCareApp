//
//  SOSView.swift
//  ElderlyCareApp
//
//  Created by MOHAN KUMMARIGUNTA on 9/15/24.
//

import SwiftUI
import FirebaseFirestore


struct SOSView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Button(action: {
                    triggerSOS()
                }) {
                    Text("Emergency SOS")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding()
                }
                .accessibilityLabel("Emergency SOS Button")
                
                Spacer()
            }
            .navigationTitle("Emergency")
        }
    }
    
    func triggerSOS() {
        // Initiate a phone call
        if let url = URL(string: "tel://911"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        // Send alert to caregivers via Firebase
        sendAlertToCaregivers()
    }
    
    func sendAlertToCaregivers() {
        let db = Firestore.firestore()
        let alert = [
            "message": "Emergency SOS triggered by user.",
            "timestamp": Timestamp(date: Date())
        ] as [String : Any]
        
        db.collection("alerts").addDocument(data: alert) { error in
            if let error = error {
                print("Error sending SOS alert: \(error)")
            } else {
                print("SOS alert sent successfully.")
            }
        }
    }
    
    
    struct SOSView_Previews: PreviewProvider {
        static var previews: some View {
            SOSView()
        }
    }
    
}
