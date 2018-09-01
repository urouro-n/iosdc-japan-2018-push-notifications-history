//
//  NotificationViewController.swift
//  PushNotificationHistoryContentExtension
//
//  Created by Kenta Nakai on 8/28/18.
//  Copyright © 2018 UROURO. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.layer.cornerRadius = 8.0
        imageView.layer.masksToBounds = true
    }

}

extension NotificationViewController: UNNotificationContentExtension {

    func didReceive(_ notification: UNNotification) {
        titleLabel.text = notification.request.content.title
    }

    func didReceive(_ response: UNNotificationResponse,
                    completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        if response.actionIdentifier == "EXAMPLE_CONTENT_ACTION1" {
            completion(.dismissAndForwardAction)
        } else {
            completion(.dismiss)
        }
    }

}
