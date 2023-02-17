//
//  JVMswitcherApp.swift
//  JVMswitcher
//
//  Created by Thomas Bonk on 15.12.22.
//  Copyright 2022, 2023 Thomas Bonk <thomas@meandmymac.de>
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

import AppKit
import SwiftKeys
import SwiftUI
import UserNotifications

@main
struct JVMswitcherApp: App {
    
    // MARK: - Public Properties
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }

        MenuBarExtra("JVMswitcher", image: "JavaIcon") {
            JVMMenuBarExtra()
                .environmentObject(model)
        }
        .menuBarExtraStyle(.automatic)

        Settings {
            ApplicationSettingsView()
        }
    }
    
    
    // MARK: - Private Properties
    
    private var model: InstalledJavaVirtualMachinesModel = {
        let model = InstalledJavaVirtualMachinesModel()
        
        try? model.reload()
        
        return model
    }()

    private let showJvmSelectHud = KeyCommand(name: .ToggleJVMListHud)


    // MARK: - Initialization

    public init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { granted, error in
            if let error {
                NSLog("Error when requesting notification authorization: \(error)")
            }

            if !granted {
                NSLog("Not authorized to show notifications.")
            }
        }

        showJvmSelectHud.observe(.keyDown) {
            
        }
    }
}
