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
                model.reload()
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            
            Button {
                do {
                    try model.selectJvm(id: selected!)
                    model.reload()
                } catch {
                    // TODO
                }
            } label: {
                Image(systemName: "checkmark.circle")
            }
            .disabled(selected == nil)
        }
    }
    
    
    // MARK: - Private Properties
    
    @State
    private var selected: String? = nil
    
    @EnvironmentObject
    private var model: InstalledJavaVirtualMachinesModel
}

struct JVMListView_Previews: PreviewProvider {
    static var previews: some View {
        JVMListView()
    }
}
