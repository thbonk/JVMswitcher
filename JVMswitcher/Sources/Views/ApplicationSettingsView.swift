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
import SwiftKeys
import SwiftUI

extension KeyCommand.Name {
    static let ToggleJVMListHud = KeyCommand.Name("ToggleJVMListHud")
}

struct ApplicationSettingsView: View {

    // MARK: - Public Properties
    
    var body: some View {
        TabView {
            Group {
                LaunchAtLogin.Toggle("Launch JVMswitcher on login")
            }
            .tabItem { Label("General", systemImage: "gear") }

            Group {
                HStack {
                    Text("Show JVM List HUD:")
                    KeyRecorderView(name: .ToggleJVMListHud)
                }
            }
            .tabItem { Label("Hotkeys", systemImage: "keyboard") }
        }
        .frame(width: 450, height: 200)
    }
}

struct ApplicationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationSettingsView()
    }
}
