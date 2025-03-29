//
//  ContentView.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 16/2/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var bleManager = BLEManager()
    @State private var userInput: String = ""
    @State private var showTextField = false

    var body: some View {
        
        VStack {
            // Bluetooth State
            Text("Bluetooth State: \(bleManager.bluetoothState)")
                .font(.headline)
                .padding()
            
            // Start/Stop Scanning Button
            Button(action: {
                if bleManager.isScanning {
                    bleManager.stopScanning()
                } else {
                    bleManager.startScanning()
                }
            }) {
                Text(bleManager.isScanning ? "Stop Scanning" : "Start Scanning")
                    .padding()
                    .background(bleManager.isScanning ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            // List of Discovered Peripherals
            List(bleManager.discoveredPeripherals, id: \.identifier) { peripheral in
                VStack(alignment: .leading) {
                    Text(peripheral.name ?? "Unknown Device")
                        .font(.headline)
                    Text("Identifier: \(peripheral.identifier.uuidString)")
                        .font(.subheadline)
                }
                .onTapGesture {
                    bleManager.connect(to: peripheral)
                    showTextField = true  // Toggle state to show the text field
                }
            }
            .padding()
            .onAppear {
                bleManager.startScanning()
            }
            
            if showTextField {
                TextField("", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Submit") {
                    bleManager.sendMessage(message: userInput)
                    showTextField = false  // Hide after submitting
                }
                .padding()
            }
        }
    }
}
