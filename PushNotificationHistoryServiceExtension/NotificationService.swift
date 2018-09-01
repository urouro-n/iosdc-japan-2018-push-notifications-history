//
//  NotificationService.swift
//  PushNotificationHistoryServiceExtension
//
//  Created by Kenta Nakai on 8/28/18.
//  Copyright © 2018 UROURO. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // 内容を修正
            bestAttemptContent.title = "<変更済み>\(bestAttemptContent.title)"

            // 画像をダウンロード
            if let urlString = bestAttemptContent.userInfo["photo_url"] as? String, let url = URL(string: urlString) {
                let task = URLSession(configuration: .default).dataTask(with: url) { (data, _, _) in
                    guard let imageData = data else {
                        contentHandler(bestAttemptContent)
                        return
                    }

                    // 一時的に画像をディスクに保存
                    let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("photo.jpg")
                    try! imageData.write(to: fileURL)

                    // 画像を通知に追加
                    let attachment = try! UNNotificationAttachment(
                        identifier: "\(Bundle.main.bundleIdentifier!).service-photo",
                        url: fileURL,
                        options: nil)

                    bestAttemptContent.attachments = [attachment]
                    contentHandler(bestAttemptContent)
                }
                task.resume()
            } else {
                contentHandler(bestAttemptContent)
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // didReceive:withContentHandler: で時間内に完了ハンドラが呼び出せない場合に呼ばれる
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
