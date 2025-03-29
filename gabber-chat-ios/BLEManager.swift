//
//  BLEManager.swift
//  gabber-chat-ios
//
//  Created by Thomas Haszard on 16/2/2025.
//

import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate {
    private var centralManager: CBCentralManager!
    private var peripheralManager: CBPeripheralManager!
    @Published var discoveredPeripherals: [CBPeripheral] = []
    @Published var connectedPeripherals: [CBPeripheral] = []
    @Published var isScanning: Bool = false
    @Published var bluetoothState: String = "Unknown"
    let serviceUUID = CBUUID(string: "94f741d6-2671-44c5-978f-ad4cbe94bf1f") // Service UUID for advertising
    private var messageCharacteristic: CBMutableCharacteristic?

    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)

    }
    
    // MARK: - Bluetooth State Handling
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            bluetoothState = "Powered On"
        case .poweredOff:
            bluetoothState = "Powered Off"
        case .resetting:
            bluetoothState = "Resetting"
        case .unauthorized:
            bluetoothState = "Unauthorized"
        case .unsupported:
            bluetoothState = "Unsupported"
        case .unknown:
            bluetoothState = "Unknown"
        @unknown default:
            bluetoothState = "Unknown"
        }
    }
    
    // MARK: - Scanning for Peripherals
    func startScanning() {
        guard centralManager.state == .poweredOn else {
            print("Cannot start scanning: Bluetooth is not powered on.")
            return
        }
        
        if !isScanning {
            discoveredPeripherals.removeAll()
            centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
            isScanning = true
        }
    }
    
    func stopScanning() {
        if isScanning {
            centralManager.stopScan()
            isScanning = false
        }
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
    
    
    // MARK: - Discovered Peripherals
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(where: { $0.identifier == peripheral.identifier }) {
            DispatchQueue.main.async {
                self.discoveredPeripherals.append(peripheral)
            }
        }
    }
    
    // MARK: - Connect to a Peripheral
    func connect(to peripheral: CBPeripheral) {
        guard centralManager.state == .poweredOn else {
            print("Cannot connect: Bluetooth is not powered on.")
            return
        }
        
        centralManager.connect(peripheral, options: nil)
        connectedPeripherals.append(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral.name ?? "Unknown")")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to peripheral: \(peripheral.name ?? "Unknown"). Error: \(error?.localizedDescription ?? "Unknown error")")
    }
    
    // MARK: - Peripheral Services and Characteristics    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print("Discovered service: \(service.uuid)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            print("Discovered characteristic: \(characteristic.uuid)")
            if characteristic.properties.contains(.writeWithoutResponse) {
                let message = "Hello, Peripheral!"
                peripheral.writeValue(message.data(using: .utf8)!, for: characteristic, type: .withoutResponse)
                print("Attempted to send message.")
            }
        }
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
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("Advertising failed: \(error.localizedDescription)")
        } else {
            print("Successfully started advertising")
        }
    }
}
