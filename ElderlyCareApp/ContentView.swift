//
//  ContentView.swift
//  ElderlyCareApp
//
//  Created by MOHAN KUMMARIGUNTA on 9/14/24.
//

import SwiftUI
import Firebase

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            MedicationViewModel()
                .tabItem {
                    Label("Medications", systemImage: "pill")
                }
            HealthView()
                .tabItem {
                    Label("Health", systemImage: "heart")
                }
            SOSView()
                .tabItem {
                    Label("SOS", systemImage: "exclamationmark.triangle")
                }
            SocialView()
                .tabItem {
                    Label("Social", systemImage: "person.3")
                }
        }
        .accentColor(.blue)
    }
}
