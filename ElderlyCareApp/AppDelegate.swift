import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        // Configure Firebase
        FirebaseApp.configure()
        
        // Set the UNUserNotificationCenter delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Set the Messaging delegate
        Messaging.messaging().delegate = self
        
        // Request notification permissions
        requestNotificationPermissions()
        
        return true
    }
    
    // Request notification permissions
    func requestNotificationPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permission denied.")
                if let error = error {
                    print("Error requesting notification permissions: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Handle the registration for remote notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass the device token to Firebase Messaging
        Messaging.messaging().apnsToken = deviceToken
        print("APNs Token received: \(deviceToken)")
    }
    
    // Handle failed registration for remote notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    // Handle FCM token refresh
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase Cloud Messaging token: \(fcmToken ?? "No token")")
        // Optionally, send the FCM token to your app server or save it for future use
    }
    
    // Handle notifications when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show notifications as banner, sound, etc. when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }
    
    // Handle notification interactions (when a user taps a notification)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle how the app should respond to the notification
        print("User interacted with the notification: \(response.notification.request.content.body)")
        completionHandler()
    }
}
