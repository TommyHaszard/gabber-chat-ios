//
//  PeripheralManager.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 1/7/2025.
//
import CoreBluetooth
import os

class PeripheralManager: NSObject, ObservableObject, CBPeripheralDelegate, CBPeripheralManagerDelegate {
    private var peripheralManager: CBPeripheralManager!
    let serviceUUID = CBUUID(string: "94f741d6-2671-44c5-978f-ad4cbe94bf1f") // Service UUID for advertising
    private let queue = DispatchQueue(label: "com.example.ble-queue", attributes: .concurrent)
    private var messageCharacteristic: CBMutableCharacteristic?

    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: queue)
    }
    
    
    // MARK: - Advertising for Peripherals
    func peripheralManagerDidUpdateState(_ peripheralManager: CBPeripheralManager) {
        if peripheralManager.state == .poweredOn {
           startAdvertising()
       } else {
           print("Bluetooth is not available")
       }
    }
    
    func startAdvertising() {
        // Create a service and a characteristic for messaging
        let messageUUID = CBUUID(string: "A1B2C3D4-E5F6-1234-5678-9ABCDEF00000")
        let characteristic = CBMutableCharacteristic(
            type: messageUUID,
            properties: [.read, .write, .notify],  // Ensure correct properties
            value: nil,
            permissions: [.readable, .writeable]
        )
        self.messageCharacteristic = characteristic
        
        let service = CBMutableService(type: serviceUUID, primary: true)
        service.characteristics = [characteristic]
        
        peripheralManager.add(service)
        
        let advertisementData: [String: Any] = [
            CBAdvertisementDataServiceUUIDsKey: [serviceUUID],
            CBAdvertisementDataLocalNameKey: "ChatPeripheral"  // Advertise with local name
        ]
        
        peripheralManager.startAdvertising(advertisementData)
        print("Started advertising with service UUID: \(serviceUUID.uuidString)")
    }
    
    
    
    // MARK: - Peripheral Services and Characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            if service.uuid == serviceUUID {
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {

    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            if request.characteristic.uuid == serviceUUID {
                if let data = request.value {
                    let receivedText = String(data: data, encoding: .utf8) ?? "<invalid>"
                    print("Received message: \(receivedText)")
                }
                peripheralManager.respond(to: request, withResult: .success)
            }
        }
    }
    
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("Advertising failed: \(error.localizedDescription)")
        } else {
            print("Successfully started advertising")
        }
    }
}
