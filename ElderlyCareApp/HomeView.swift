//
//  HomeView.swift
//  ElderlyCareApp
//
//  Created by MOHAN KUMMARIGUNTA on 9/15/24.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @StateObject private var healthKitManager = HealthKitManager()
    @StateObject private var medicationViewModel = MedicationViewModel()
    @StateObject private var activityViewModel = ActivityViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Health Metrics Section
                    VStack(alignment: .leading) {
                        Text("Health Metrics")
                            .font(.headline)
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Heart Rate")
                                    .font(.subheadline)
                                Text("\(healthKitManager.heartRate, specifier: "%.0f") BPM")
                                    .font(.title2)
                                    .foregroundColor(.red)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Blood Pressure")
                                    .font(.subheadline)
                                Text("\(healthKitManager.bloodPressureSystolic, specifier: "%.0f") / \(healthKitManager.bloodPressureDiastolic, specifier: "%.0f") mmHg")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    // Medication Reminders Section
                    VStack(alignment: .leading) {
                        Text("Upcoming Medications")
                            .font(.headline)
                        if medicationViewModel.reminders.isEmpty {
                            Text("No upcoming medications.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(medicationViewModel.reminders) { reminder in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(reminder.name)
                                            .font(.subheadline)
                                        Text("Dosage: \(reminder.dosage)")
                                            .font(.caption)
                                        Text("Time: \(reminder.time, formatter: DateFormatter.timeFormatter)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    }
                    
                    // Recent Activities Section
                    VStack(alignment: .leading) {
                        Text("Recent Activities")
                            .font(.headline)
                        if activityViewModel.activities.isEmpty {
                            Text("No recent activities.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(activityViewModel.activities.prefix(3)) { activity in
                                VStack(alignment: .leading) {
                                    Text(activity.title)
                                        .font(.subheadline)
                                    Text(activity.description)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("\(activity.date, formatter: DateFormatter.activityDateFormatter)")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    }
                    
                    // Quick Access to SOS
                    VStack(alignment: .center) {
                        Button(action: {
                            // Navigate to SOSView
                        }) {
                            Text("Emergency SOS")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        .accessibilityLabel("Emergency SOS Button")
                    }
                }
                .padding()
            }
            .navigationTitle("Home")
            .onAppear {
                healthKitManager.requestAuthorization()
                medicationViewModel.loadReminders()
                activityViewModel.fetchActivities()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

// Single valid declaration of timeFormatter
extension DateFormatter {
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}
