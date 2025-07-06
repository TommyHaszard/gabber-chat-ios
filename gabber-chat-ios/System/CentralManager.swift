import CoreBluetooth
import os
//
//  PeripheralManager.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 1/7/2025.
//

// Protocol to delegate data back to the main app
protocol CentralManagerDelegate: AnyObject {
    func centralManager(didUpdateValue value: String, from peripheral: CBPeripheral)
    func centralManager(didConnect peripheral: CBPeripheral)
}

class CentralManager: NSObject, ObservableObject, CBCentralManagerDelegate {
    private var centralManager: CBCentralManager!
    let serviceUUID = CBUUID(string: "94f741d6-2671-44c5-978f-ad4cbe94bf1f") // Service UUID for advertising
    weak var delegate: CentralManagerDelegate?
    private var connectedPeripherals: [CBPeripheral] = []
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: - Bluetooth State Handling
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        

    }
    
    // MARK: - Discovered Peripherals
        func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        os_log("Discovered peripheral: %@", peripheral.name ?? "Unknown")

        if !connectedPeripherals.contains(peripheral) {
            // check that the periphera contains the service we're looking for
            peripheral.discoverServices([serviceUUID])
            centralManager.connect(peripheral, options: nil)
            
        }
    }
    
    // MARK: - Fail to connect to Peripheral logic
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to peripheral: \(peripheral.name ?? "Unknown"). Error: \(error?.localizedDescription ?? "Unknown error")")
    }
    
    func sendMessage(message: String) {
        if connectedPeripherals.isEmpty {
            print("No discovered peripherals.")
            return
        }
        
        let data = message.data(using: .utf8)
        for peripheral in connectedPeripherals {
            guard let services = peripheral.services else { return }
            for service in services {
                guard let characteristics = service.characteristics else { return }
                for characteristic in characteristics {
                    if characteristic.properties.contains(.writeWithoutResponse) {
                        peripheral.writeValue(data!, for: characteristic, type: .withoutResponse)
                        print("Attempted to send message.")
                    }
                }
            }
        }
    }

}

