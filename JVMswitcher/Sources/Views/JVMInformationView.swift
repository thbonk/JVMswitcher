//
//  JVMInformationView.swift
//  JVMswitcher
//
//  Created by Thomas Bonk on 17.02.23.
//

import SwiftUI

struct JVMInformationView: View {

    // MARK: - Public Properties

    var body: some View {
        NavigationSplitView {
            List(model.virtualMachines, id: \.id, selection: $selectedVm) { vm in
                NavigationLink(value: vm) {
                    Text("\(vm.name) (\(vm.vendor))")
                }

            }
        } detail: {
            if let selectedVm {
                VStack {
                    LazyVGrid(columns: [.init(alignment: .trailing), .init(alignment: .leading)]) {
                        Group {
                            Text("Name:")
                                .bold()
                            Text(selectedVm.name)
                        }.padding(.bottom, 10)

                        Group {
                            Text("Version:")
                                .bold()
                            Text(selectedVm.version)
                        }.padding(.bottom, 10)

                        Group {
                            Text("Vendor:")
                                .bold()
                            Text(selectedVm.vendor)
                        }.padding(.bottom, 10)

                        Group {
                            Text("Architecture:")
                                .bold()
                            Text(selectedVm.architecture)
                        }.padding(.bottom, 10)

                        Group {
                            Text("Installation Path:")
                                .bold()
                            Link("\(selectedVm.path)", destination: URL(fileURLWithPath: selectedVm.path))
                                .environment(\.openURL, OpenURLAction { url in
                                    NSWorkspace.shared.open(url)
                                    return .handled
                                })
                        }.padding(.bottom, 10)
                    }
                    .padding(.top, 10)
                    Spacer()
                }
            }
        }
    }

    // MARK: - Private Properties

    @EnvironmentObject
    private var model: InstalledJavaVirtualMachinesModel

    @State
    private var selectedVm: InstalledJavaVirtualMachinesModel.VirtualMachine? = nil
}

struct JVMInformationView_Previews: PreviewProvider {
    static var previews: some View {
        JVMInformationView()
    }
}
