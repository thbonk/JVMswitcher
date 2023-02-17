//
//  InstalledJavaVirtualMachinesModel.swift
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

import Combine
import Foundation

fileprivate extension URL {
    static var currentJvmLink: URL {
        return FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".currentJVM")
    }
}

class InstalledJavaVirtualMachinesModel: ObservableObject {
    
    // MARK: - Virtual Machone Description
    
    struct VirtualMachine: Identifiable, Hashable {
        let version: String
        let architecture: String
        let vendor: String
        let name: String
        let path: String
        
        var id: String {
            return path
        }
    }
    
    
    // MARK: - Public Properties
    
    @Published
    private(set) var virtualMachines: [VirtualMachine] = []
    
    // This is a dirty trick to trigger an update of all views
    @Published
    private(set) var updateCount = 0
    
    var selectedJvm: String? {
        if let ok = try? URL.currentJvmLink.checkResourceIsReachable(), ok {
            let vals = try? URL.currentJvmLink.resourceValues(forKeys: [.isSymbolicLinkKey])
            
            if let islink = vals?.isSymbolicLink, islink {
                let dest = URL.currentJvmLink.resolvingSymlinksInPath()
                
                if dest != URL.currentJvmLink {
                    var result = dest.path()
                    
                    if result.last == "/" {
                        result = String(result.dropLast())
                    }
                    return result
                }
            }
        }
        
        return nil
    }
    
    
    
    // MARK: - Public Methods
    
    func selectJvm(id: String) throws -> VirtualMachine? {
        if id != selectedJvm {
            if FileManager.default.fileExists(atPath: URL.currentJvmLink.path()) {
                try FileManager.default.removeItem(at: URL.currentJvmLink)
            }
            try FileManager.default.createSymbolicLink(at: URL.currentJvmLink, withDestinationURL: URL(filePath: id))
            
            DispatchQueue.main.async {
                self.updateCount += 1
            }

            return virtualMachines.first { vm in vm.id == id }
        }

        return nil
    }
    
    func reload() throws {
        let pattern = /(.*) (.*) "(.*)" - "(.*)" (.*)/
        let jvms = try readFromJavaHomeTool()
        var descriptions: [VirtualMachine] = []
        
        jvms.forEach { line in
            if let result = try? pattern.wholeMatch(in: line) {
                descriptions
                    .append(
                        VirtualMachine(
                            version: String(result.1),
                            architecture: String(result.2),
                            vendor: String(result.3),
                            name: String(result.4),
                            path: String(result.5)))
            }
        }
        
        self.virtualMachines.removeAll()
        self.virtualMachines.append(contentsOf: descriptions)
    }
    
    
    // MARK: - Private Methods
    
    private func readFromJavaHomeTool() throws -> [String] {
        let task = Process()
        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        
        task.executableURL = URL(fileURLWithPath: "/usr/libexec/java_home")
        task.arguments = ["-V"]
        task.standardOutput = stdoutPipe
        task.standardError = stderrPipe
        
        try task.run()
        
        let handle = stderrPipe.fileHandleForReading
        let data = handle.readDataToEndOfFile()
        
        let output = String(data: data, encoding: String.Encoding.utf8)!
        
        return output.components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    
}
