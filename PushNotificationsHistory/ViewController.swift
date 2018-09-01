//
//  ViewController.swift
//  iosdc-japan-2018-push-notifications-history
//
//  Created by Kenta Nakai on 8/18/18.
//  Copyright © 2018 UROURO. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // プッシュ通知を許可する
    @IBAction func didTapRegisterButton(_ sender: Any) {
        (UIApplication.shared.delegate as? AppDelegate)?.requestAuthorization()
    }

    // カスタムアクションのローカル通知
    @IBAction func didTapCustomActionButton(_ sender: Any) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["LOCAL_EXAMPLE_30"])

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false) // 30秒後に通知
            let content = UNMutableNotificationContent()
            content.title = "カスタムアクションつきローカル通知のサンプル"
            content.subtitle = "30秒後の通知"
            content.body = "カスタムアクションつきローカル通知のサンプルです"
            content.badge = 1
            content.categoryIdentifier = "EXAMPLE" // category.identifier を指定
            let request = UNNotificationRequest(identifier: "LOCAL_EXAMPLE_30", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    debugPrint("\(#function) error: \(error)")
                }
            }

            debugPrint("\(#function) request: \(request)")

            let alert = UIAlertController(title: "30秒後に通知します", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)

        } else {
            UIApplication.shared.cancelAllLocalNotifications()

            let notification = UILocalNotification()
            let calendar = Calendar.current
            notification.fireDate = calendar.date(byAdding: .second, value: 30, to: Date()) // 30秒後に通知
            notification.timeZone = TimeZone.current
            notification.alertBody = "カスタムアクションつきローカル通知のサンプル"
            notification.applicationIconBadgeNumber = 1
            notification.category = "EXAMPLE" // category.identifier を指定
            UIApplication.shared.scheduleLocalNotification(notification)

            debugPrint("\(#function) notification: \(notification)")

            let alert = UIAlertController(title: "30秒後に通知します", message: "アプリケーションをバックグラウンドにしてください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    // getPendingNotificationRequests (iOS 10)
    @IBAction func didTapGetPendingNotificationsButton(_ sender: Any) {
        if #available(iOS 10.0, *) {
            // 実行前の通知リクエストを取得
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                debugPrint("\(#function) requests: \(requests)")
            }
        }
    }

    // getDeliveredNotifications (iOS 10)
    @IBAction func didTapGetDeliveredNotificationsButton(_ sender: Any) {
        if #available(iOS 10.0, *) {
            // 送信されている通知を取得
            UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
                debugPrint("\(#function) count: \(notifications.count)")
                notifications.forEach { debugPrint("notification: \($0)") }
            }
        }
    }

    // removeAllPendingNotificationRequests (iOS 10)
    @IBAction func didTapRemoveAllPendingNotificationsButton(_ sender: Any) {
        if #available(iOS 10.0, *) {
            // 実行前の通知リクエストをすべて削除
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

            // 個別に削除する場合は `removePendingNotificationRequests(withIdentifiers:)`
            // UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["LOCAL_EXAMPLE_30"])
        }
    }

    // removeAllDeliveredNotifications (iOS 10)
    @IBAction func didTapRemoveAllDeliveredNotificationsButton(_ sender: Any) {
        if #available(iOS 10.0, *) {
            // 送信されている通知をすべて削除
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()

            // 個別に削除する場合は `removeDeliveredNotifications(withIdentifiers:)`
            // UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["REMOTE_GREETING"])
        }
    }

    // 画像つきのローカル通知 (iOS 10)
    @IBAction func didTapMediaLocalNotificationButton(_ sender: Any) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["LOCAL_EXAMPLE_IMAGE"])

            let attachment = try! UNNotificationAttachment(
                identifier: "\(Bundle.main.bundleIdentifier!).hello-image",
                url: Bundle.main.url(forResource: "hello-image", withExtension: "png")!,
                options: nil)

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false) // 3秒後に通知
            let content = UNMutableNotificationContent()
            content.title = "タイトル"
            content.subtitle = "サブタイトル"
            content.body = "本文本文本文..."
            content.attachments = [attachment]
            content.categoryIdentifier = "EXAMPLE"

            let request = UNNotificationRequest(identifier: "LOCAL_EXAMPLE_IMAGE", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    debugPrint("\(#function) error: \(error)")
                }
            }

            debugPrint("\(#function) request: \(request)")
        }
    }

    // 通知設定の取得 (iOS 10)
    @IBAction func didTapGetNotificationSettingsButton(_ sender: Any) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                debugPrint(#function, "settings: \(settings)")
            }
        }
    }

}

