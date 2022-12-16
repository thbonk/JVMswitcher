//
//  JVMListView.swift
//  JVMswitcher
//
//  Created by Thomas Bonk on 15.12.22.
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

import AlertToast
import SwiftUI

struct JVMListView: View {
    
    // MARK: Public Proeprties
    
    var body: some View {
        List(selection: $selected) {
            ForEach(model.virtualMachines, id: \.id) { vm in
                HStack {
                    Rectangle()
                        .frame(width: 5)
                        .foregroundColor(vm.id == model.selectedJvm ? .green : .clear)
                        .cornerRadius(2)
                    VStack {
                        HStack(alignment: .center) {
                            Text(vm.name)
                                .font(.title2).bold()
                            Spacer()
                            Text(vm.version)
                        }
                        
                        HStack {
                            Text(vm.vendor)
                            Spacer()
                        }
                    }
                    .id(vm.id)
                }
            }
        }
        .toolbar {
            Button {
                do {
                    try model.reload()
                } catch {
                    show(message: "Can't load the installed JVMs.", error: error)
                }
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            
            Button {
                do {
                    let showInfo = selected != model.selectedJvm

                    try model.selectJvm(id: selected!)
                    try model.reload()

                    if showInfo {
                        show(info: "JVM selected.")
                    }
                } catch {
                    show(message: "Selecting the JVM failed.", error: error)
                }
            } label: {
                Image(systemName: "checkmark.circle")
            }
            .disabled(selected == nil)
        }
        .toast(isPresenting: $showToast) {
            AlertToast(
                displayMode: toastData?.displayMode ?? .alert,
                type: toastData?.alertType ?? .regular,
                title: toastData?.title,
                subTitle: toastData?.subtitle,
                style: toastData?.style)
        }
    }
    
    
    // MARK: - Private Properties
    
    @State
    private var selected: String? = nil
    @State
    private var showToast = false
    @State
    private var toastData: ToastData?
    
    @EnvironmentObject
    private var model: InstalledJavaVirtualMachinesModel


    // MARK: - Private Methods

    private func show(message: String, error: Error) {
        toastData = ToastData(
            displayMode: .alert,
            alertType: .error(.red),
            title: "Error",
            subtitle: "\(message)\n\(error.localizedDescription)")
        showToast = true
    }

    private func show(info message: String) {
        toastData = ToastData(
            displayMode: .banner(.slide),
            alertType: .complete(.green),
            title: "Information",
            subtitle: "\(message)")
        showToast = true
    }
}

struct JVMListView_Previews: PreviewProvider {
    static var previews: some View {
        JVMListView()
    }
}
