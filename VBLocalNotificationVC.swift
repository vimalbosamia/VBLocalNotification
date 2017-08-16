//
//  VBLocalNotificationVC.swift
//
//  Created by Vimal on 8/16/17.
//  Copyright © 2017 Crypton. All rights reserved.
//

import UIKit
import UserNotifications
class VBLocalNotificationVC: UIViewController , UNUserNotificationCenterDelegate {

      var notificationContent = UNMutableNotificationContent()
    override func viewDidLoad() {
        super.viewDidLoad()

          UNUserNotificationCenter.current().delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnActionSave(_ sender: Any) {
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    // Schedule Local Notification
                    self.scheduleLocalNotification()
                })
            case .authorized:
                // Schedule Local Notification
                self.scheduleLocalNotification()
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
    }

    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            completionHandler(success)
        }
    }

    private func scheduleLocalNotification() {
        // Create Notification Content
        let  time = 5 //miniute
        let finalTime : Int = time * 60
        let flTime : Double = Double (finalTime)
        print(flTime)
        // let notificationContent = UNMutableNotificationContent()
        // Configure Notification Content
        notificationContent.title = "Title"
        notificationContent.body = "Local notification bosy"
        notificationContent.sound = UNNotificationSound(named:"drop.caf") // if u want to customized notification sound
        let reminder = UILocalNotification()
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let date = (cal as NSCalendar).date(bySettingHour: 0, minute: 0, second: 0, of: Date(), options: NSCalendar.Options())
        reminder.fireDate = date
        reminder.repeatInterval = NSCalendar.Unit.day
        UIApplication.shared.scheduleLocalNotification(reminder)
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval:flTime, repeats: true)
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension VBLocalNotificationVC: UNUserNotificationCenterDelegate {

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }

    @available(iOS 10.0, *)
    open func getPendingNotificationRequests(completionHandler: @escaping ([UNNotificationRequest]) -> Swift.Void)
    {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            print("Requests: \(notificationRequests)")
        }
    }
}

