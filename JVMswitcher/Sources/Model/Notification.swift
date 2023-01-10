//
//  Notification.swift
//  JVMswitcher
//
//  Created by Thomas Bonk on 05.01.23.
//  Copyright 2022 Thomas Bonk <thomas@meandmymac.de>
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import UserNotifications

struct Notification {

    // MARK: - Private Properties

    fileprivate let title: String
    fileprivate let subtitle: String?
    fileprivate let body: String
    fileprivate let sound: UNNotificationSound


    // MARK: - Static Methods

    static func error(subtitle: String? = nil, message: String, error: Error) -> Notification {
        return Notification(
            title: "Error",
            subtitle: subtitle,
            body: "\(message)\n\(error.localizedDescription)",
            sound: UNNotificationSound.defaultCritical)
    }

    static func info(subtitle: String? = nil, message: String) -> Notification {
        return Notification(
            title: "Information",
            subtitle: subtitle,
            body: message,
            sound: UNNotificationSound.default)
    }


    // MARK: - Public Methods

    func show() {
        let content = UNMutableNotificationContent()
        content.title = title
        if let subtitle {
            content.subtitle = subtitle
        }
        content.body = body
        content.sound = sound

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil)

        UNUserNotificationCenter.current().add(request)
    }
}
