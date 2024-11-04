//
//  HealthKitManager.swift
//  ElderlyCareApp
//
//  Created by MOHAN KUMMARIGUNTA on 9/15/24.
//

import Foundation
import HealthKit
import Combine

class HealthKitManager: ObservableObject {
    private var healthStore = HKHealthStore()
    
    @Published var heartRate: Double = 0.0
    @Published var bloodPressureSystolic: Double = 0.0
    @Published var bloodPressureDiastolic: Double = 0.0
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!,
            HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
            if success {
                self.fetchLatestHeartRate()
                self.fetchLatestBloodPressure()
            } else {
                if let error = error {
                    print("HealthKit Authorization Error: \(error)")
                }
            }
        }
    }
    
    func fetchLatestHeartRate() {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
            if let sample = samples?.first as? HKQuantitySample {
                DispatchQueue.main.async {
                    self.heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                }
            }
        }
        healthStore.execute(query)
    }
    
    func fetchLatestBloodPressure() {
        guard let systolicType = HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic),
              let diastolicType = HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic) else { return }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        // Systolic
        let systolicQuery = HKSampleQuery(sampleType: systolicType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
            if let sample = samples?.first as? HKQuantitySample {
                DispatchQueue.main.async {
                    self.bloodPressureSystolic = sample.quantity.doubleValue(for: HKUnit(from: "mmHg"))
                }
            }
        }
        
        // Diastolic
        let diastolicQuery = HKSampleQuery(sampleType: diastolicType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
            if let sample = samples?.first as? HKQuantitySample {
                DispatchQueue.main.async {
                    self.bloodPressureDiastolic = sample.quantity.doubleValue(for: HKUnit(from: "mmHg"))
                }
            }
        }
        
        healthStore.execute(systolicQuery)
        healthStore.execute(diastolicQuery)
    }
}

