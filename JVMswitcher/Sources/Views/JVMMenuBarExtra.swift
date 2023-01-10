//
//  JVMMenuBarExtra.swift
//  JVMswitcher
//
//  Created by Thomas Bonk on 20.12.22.
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

import SwiftUI

struct JVMMenuBarExtra: View {

    // MARK: - Public Properties

    var body: some View {
        VStack {
            ForEach(model.virtualMachines, id: \.id) { vm in
                Toggle(isOn: jvmSelected(vm.id)) {
                    Text("\(vm.name) (\(vm.vendor))")
                }
            }
        }
    }


    // MARK: - Private Properties

    @EnvironmentObject
    private var model: InstalledJavaVirtualMachinesModel


    // MARK: - Private Methods

    private func jvmSelected(_ id: String) -> Binding<Bool> {
        return Binding {
            id == model.selectedJvm
        } set: { value in
            if value {
                do {
                    let showInfo = id != model.selectedJvm

                    let selectedVm = try model.selectJvm(id: id)
                    try model.reload()

                    if let selectedVm, showInfo {
                        Notification
                            .info(message: "JVM \(selectedVm.name) selected.")
                            .show()
                    }
                } catch {
                    Notification
                        .error(message: "Selecting the JVM failed.", error: error)
                        .show()
                }
            }
        }
    }
}

struct JVMMenuBarExtra_Previews: PreviewProvider {
    static var previews: some View {
        JVMMenuBarExtra()
    }
}
