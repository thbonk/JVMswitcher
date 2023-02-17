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
import SwiftUI
import UserNotifications

fileprivate extension String {
    static let JVMInformationWindowId = "__JVMInformationWindowId__"
}

@main
struct JVMswitcherApp: App {
    
    // MARK: - Public Properties
    
    var body: some Scene {
        MenuBarExtra("JVMswitcher", image: "JavaIcon") {
            JVMList()
                .environmentObject(model)
            Divider()
            Button("About JVMswitcher...") {
                NSApp.showAboutPanel()
            }
            Divider()
            Button("Show JVM Informations...") {
                open(windowId: .JVMInformationWindowId)
            }
            Button("Settings...") {
                NSApp.showAppSettings()
            }
            Divider()
            Button("Quit JVMswitcher") {
                NSApp.terminate(self)
            }
        }
        .menuBarExtraStyle(.automatic)

        Window("JVM Informations", id: .JVMInformationWindowId) {
            JVMInformationView()
                .environmentObject(model)
        }

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

    @Environment(\.openWindow)
    private var openWindow


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
    }


    // MARK: - Private Methods

    private func open(windowId: String) {
        openWindow(id: .JVMInformationWindowId)
        activateApp()
    }

    private func activateApp() {
        DispatchQueue.main.async {
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
