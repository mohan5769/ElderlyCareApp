//
//  HealthView.swift
//  ElderlyCareApp
//
//  Created by MOHAN KUMMARIGUNTA on 9/15/24.
//

import SwiftUI

struct HealthView: View {
    @StateObject private var healthKitManager = HealthKitManager()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Heart Rate Section
                VStack(alignment: .leading) {
                    Text("Heart Rate")
                        .font(.headline)
                    Text("\(healthKitManager.heartRate, specifier: "%.0f") BPM")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // Blood Pressure Section
                VStack(alignment: .leading) {
                    Text("Blood Pressure")
                        .font(.headline)
                    Text("\(healthKitManager.bloodPressureSystolic, specifier: "%.0f") / \(healthKitManager.bloodPressureDiastolic, specifier: "%.0f") mmHg")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Health Monitoring")
            .onAppear {
                healthKitManager.requestAuthorization()
            }
        }
    }
}

struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView()
    }
}

