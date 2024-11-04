//
//  MedicationView.swift
//  ElderlyCareApp
//
//  Created by MOHAN KUMMARIGUNTA on 9/15/24.
//

import SwiftUI
import Firebase

// Extension for DateFormatter (corrected to have only one declaration)
extension DateFormatter {
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}

struct HomeView: View {
    @StateObject private var healthKitManager = HealthKitManager()
    @StateObject private var medicationViewModel = MedicationViewModel()
    @StateObject private var activityViewModel = ActivityViewModel()

    var body: some View {
        VStack {
            Text("Welcome to Elderly Care App")
                .font(.largeTitle)
                .padding()

            // Other UI components and content
        }
    }
}

struct MedicationView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationView()
    }
}
