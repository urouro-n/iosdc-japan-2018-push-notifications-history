//
//  AppDelegate.swift
//  iosdc-japan-2018-push-notifications-history
//
//  Created by Kenta Nakai on 8/18/18.
//  Copyright © 2018 UROURO. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }

        return true
    }

    // MARK: Register Remote Notification

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // デバイストークンの表示
        debugPrint("\(#function) deviceToken: \(deviceToken.map { String(format: "%.2hhx", $0) }.joined())")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint("\(#function) error: \(error)")
    }

}

extension AppDelegate {

    // カスタムアクションを含むカテゴリの設定例 (iOS 10 から)
    @available(iOS 10.0, *)
    var customActionsExampleCategory: UNNotificationCategory {
        // アクション時, アプリを起動する
        let example1Action = UNNotificationAction(identifier: "EXAMPLE_ACTION1",
                                                  title: "アクションその1 (アプリ起動)",
                                                  options: [.foreground])

        // バックグラウンドでアクションを処理
        let example2Action = UNNotificationAction(identifier: "EXAMPLE_ACTION2",
                                                  title: "アクションその2 (バックグラウンド)")

        // テキスト入力
        let example3Action = UNTextInputNotificationAction(identifier: "EXAMPLE_ACTION3",
                                                           title: "アクションその3 (テキスト入力)",
                                                           textInputButtonTitle: "送信！",
                                                           textInputPlaceholder: "テキストを入力してください...")

        // 破壊的なアクションを行う場合, 赤色で表示できる
        let example4Action = UNNotificationAction(identifier: "EXAMPLE_ACTION4",
                                                  title: "アクションその4 (破壊的アクション)",
                                                  options: [.destructive])

        if #available(iOS 11.0, *) {
            return UNNotificationCategory(identifier: "EXAMPLE",
                                          actions: [example1Action, example2Action, example3Action, example4Action],
                                          intentIdentifiers: [],
                                          hiddenPreviewsBodyPlaceholder: "%u件のサンプルを非表示", // Hidden Notification Content
                                          options: [.customDismissAction])
        } else {
            return UNNotificationCategory(identifier: "EXAMPLE",
                                          actions: [example1Action, example2Action, example3Action, example4Action],
                                          intentIdentifiers: [],
                                          options: [.customDismissAction])

        }
    }

    // Notification Content Extension 用カテゴリ
    @available(iOS 10.0, *)
    var contentExtensionExampleCategory: UNNotificationCategory {
        let action1 = UNNotificationAction(identifier: "EXAMPLE_CONTENT_ACTION1",
                                          title: "アプリを開く")

        return UNNotificationCategory(identifier: "EXAMPLE_CONTENT",
                                      actions: [action1],
                                      intentIdentifiers: [],
                                      options: [])
    }

    func requestAuthorization() {
        if #available(iOS 10.0, *) {
            // カスタムアクションのカテゴリの登録
            UNUserNotificationCenter.current().setNotificationCategories([
                customActionsExampleCategory, contentExtensionExampleCategory])

            // 通知設定を登録
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                debugPrint("granted: \(granted), error: \(String(describing: error))")

                if granted {
                    DispatchQueue.main.async {
                        // リモート通知の登録
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            // カスタムアクションのカテゴリの登録 (iOS 9 まで)
            let example1Action = UIMutableUserNotificationAction()
            example1Action.identifier = "EXAMPLE_ACTION1"
            example1Action.title = "その1 (アプリ起動)"
            example1Action.activationMode = .foreground
            example1Action.isDestructive = false

            let example2Action = UIMutableUserNotificationAction()
            example2Action.identifier = "EXAMPLE_ACTION2"
            example2Action.title = "その2 (バックグラウンド)"
            example2Action.activationMode = .background
            example2Action.isDestructive = false

            let example3Action = UIMutableUserNotificationAction()
            example3Action.identifier = "EXAMPLE_ACTION3"
            example3Action.title = "その3 (テキスト入力)"
            example3Action.isDestructive = false
            example3Action.behavior = .textInput

            let example4Action = UIMutableUserNotificationAction()
            example4Action.identifier = "EXAMPLE_ACTION4"
            example4Action.title = "その4 (破壊的アクション)"
            example4Action.isDestructive = true

            let category = UIMutableUserNotificationCategory()
            category.identifier = "EXAMPLE"
            category.setActions([example1Action, example2Action, example3Action, example4Action], for: .default)
            let categories: Set<UIUserNotificationCategory> = [category]

            // 通知設定を登録（許可ダイアログが表示）
            let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: categories)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }

}

// MARK: - iOS 9.0以下
extension AppDelegate {

    // MARK: 通知設定

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        debugPrint("\(#function) types: \(notificationSettings.types)")
        debugPrint("\(#function) categories: \(String(describing: notificationSettings.categories))")

        // リモート通知の登録
        UIApplication.shared.registerForRemoteNotifications()
    }

    // MARK: 通知の受信

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        debugPrint("\(#function) notification: \(notification)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        debugPrint("\(#function) userInfo: \(userInfo)")

        // バックグラウンドでデータを取得...

        // 取得結果に応じた UIBackgroundFetchResult を completionHandler に渡す
        completionHandler(.noData)
    }

    // MARK: カスタムアクション

    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        debugPrint("\(#function) identifier: \(String(describing: identifier)), notification: \(notification)")
        completionHandler()
    }

    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        debugPrint("\(#function) identifier: \(String(describing: identifier)), notification: \(notification), responseInfo: \(responseInfo)")
        completionHandler()
    }

    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        debugPrint("\(#function) identifier: \(String(describing: identifier)), userInfo: \(userInfo)")
        completionHandler()
    }

    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        debugPrint("\(#function) identifier: \(String(describing: identifier)), userInfo: \(userInfo), responseInfo: \(responseInfo)")
        completionHandler()
    }

}

// MARK: iOS 10.0以上 (User Notification Framework)
extension AppDelegate: UNUserNotificationCenterDelegate {

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // アプリがフォアグラウンドにいるときに通知を受け取ると呼ばれる

        let userInfo = notification.request.content.userInfo
        debugPrint("\(#function) userInfo: \(userInfo)")

        // 反映する種類を指定
        completionHandler([.alert, .badge, .sound]) // アプリ起動中でも届いた通知を表示する
        // completionHandler([]) // 何も表示しない
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 通知からアプリを開いたり、カスタムアクションを実行した場合に呼ばれる

        let userInfo = response.notification.request.content.userInfo

        // カスタムアクション選択時の identifier
        let actionIdentifier = response.actionIdentifier

        // カスタムアクションのテキスト入力があった場合の内容
        let userText = (response as? UNTextInputNotificationResponse)?.userText

        debugPrint("\(#function) userInfo: \(userInfo), actionIdentifier: \(actionIdentifier), userText: \(String(describing: userText))")

        switch actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            // 通常の起動
            break
        case UNNotificationDismissActionIdentifier:
            // 通知の消去
            break
        case "EXAMPLE_ACTION1":
            // カスタムアクション
            break
        default:
            break
        }

        completionHandler()
    }

}
