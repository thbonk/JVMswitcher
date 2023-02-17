//
//  ApplicationSettingsView.swift
//  JVMswitcher
//
//  Created by Thomas Bonk on 10.01.23.
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

import LaunchAtLogin
import SwiftUI

struct ApplicationSettingsView: View {

    // MARK: - Public Properties
    
    var body: some View {
        VStack {
            LaunchAtLogin.Toggle("Launch JVMswitcher on login")
                .padding(.bottom, 20)

            if !rescanInProgress {
                Button("Rescan installed JVMs") {
                    rescanJVMs()
                }
            } else {
                ProgressView()
            }
        }
        .padding()
    }


    // MARK: - Private Properties

    @State
    private var rescanInProgress = false


    // MARK: - Private Methods

    private func rescanJVMs() {
        Task {
            let task = Process()
            task.launchPath = "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"
            task.arguments = [
                "-kill",
                "-r",
                "-domain", "local",
                "-domain", "system",
                "-domain", "user"
            ]

            task.launch()

            DispatchQueue.main.async {
                rescanInProgress = true
            }

            // Wait for the command to finish
            task.waitUntilExit()

            DispatchQueue.main.async {
                rescanInProgress = false
                Notification.info(message: "Rescan of JVMs finished").show()
            }
        }
    }
}

struct ApplicationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationSettingsView()
    }
}
