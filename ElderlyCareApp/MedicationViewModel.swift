//
//  MedicationViewModel.swift
//  ElderlyCareApp
//
//  Created by MOHAN KUMMARIGUNTA on 9/15/24.
//

import Foundation
import UserNotifications

struct MedicationReminder: Identifiable, Codable {
    let id: String
    let name: String
    let dosage: String
    let time: Date
}

class MedicationViewModel: ObservableObject {
    @Published var reminders: [MedicationReminder] = []
    
    // Save reminders locally using UserDefaults for simplicity
    func addReminder(name: String, dosage: String, time: Date) {
        let newReminder = MedicationReminder(id: UUID().uuidString, name: name, dosage: dosage, time: time)
        reminders.append(newReminder)
        scheduleNotification(for: newReminder)
        saveReminders()
    }
    
    func scheduleNotification(for reminder: MedicationReminder) {
        let content = UNMutableNotificationContent()
        content.title = "Time to take \(reminder.name)"
        content.body = "Dosage: \(reminder.dosage)"
        content.sound = .default
        
        // Create trigger
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: reminder.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        
        // Create request
        let request = UNNotificationRequest(identifier: reminder.id, content: content, trigger: trigger)
        
        // Schedule notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func saveReminders() {
        if let encoded = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(encoded, forKey: "medicationReminders")
        }
    }
    
    func loadReminders() {
        if let savedData = UserDefaults.standard.data(forKey: "medicationReminders"),
           let decoded = try? JSONDecoder().decode([MedicationReminder].self, from: savedData) {
            reminders = decoded
        }
    }
}

