//
//  UserDisplayController.swift
//  BlutoothCom
//
//  Created by David on 09/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import CoreBluetooth

class UserDisplayController: UITableViewController {
    
    let peripheralCellId = "peripheralCellId"
    var visibleDevices = [Device]()
    var cachedDevices = [Device]()
    var cachedPeripheralNames = NSCache<NSString, NSString>()
    var timer = Timer()
    
    var keepScanning = false
    let timerScanInterval:TimeInterval = 2
    let timerPauseBeforeNextScanInterval: TimeInterval = 8
    
    var centralManager: CBCentralManager?
    var peripheralManager = CBPeripheralManager()
    
    // MARK: - View Lifecycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBarButton = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(handleProfileButtonTap))
        navigationItem.setRightBarButton(rightBarButton, animated: true)
        
        tableView.register(UserCell.self, forCellReuseIdentifier: peripheralCellId)
        
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        scheduledTimerWithTimeInterval()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateAdvertisingData()
        startScanningForBLEDevices()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        keepScanning = false
    }
    
    private func updateAdvertisingData() {
        
        if peripheralManager.isAdvertising {
            peripheralManager.stopAdvertising()
        }
        
        let userData = UserData()
        let advertismentData = "\(userData.name)|\(userData.avatarId)|\(userData.colorId)"
        
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [Constants.SERVICE_UUID], CBAdvertisementDataLocalNameKey: advertismentData])
    }
    
    func addOrUpdatePeripheralList(device: Device, list: [Device], completion: @escaping(_ deviceOrName: (Device?, String?, Int?)) -> ()) {
        
        if !list.contains(where: { $0.peripheral.identifier == device.peripheral.identifier }) {
            // add new peripheral 
            completion((device, nil, nil))
        }
        else if list.contains(where: { $0.peripheral.identifier == device.peripheral.identifier
            && $0.name == "unknown"}) && device.name != "unknown" {
            // update peripheral list
            for index in 0..<list.count {
                
                if (list[index].peripheral.identifier == device.peripheral.identifier) {
                    completion((nil, device.name, index))
                    break
                }
            }
            
        }
    }
    
    private func scheduledTimerWithTimeInterval() {
        timer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(clearPeripherals), userInfo: nil, repeats: true)
    }
    
    @objc private func clearPeripherals() {
        visibleDevices = cachedDevices
        cachedDevices.removeAll()
        tableView.reloadData()
    }
    
    @objc func handleProfileButtonTap() {
        
        let registerController = RegiserController()
        navigationController?.pushViewController(registerController, animated: true)
        
    }
    
    // MARK: - Bluetooth scanning

    private func startScanningForBLEDevices() {
        
        keepScanning = true
    
        _ = Timer(timeInterval: timerScanInterval, target: self, selector: #selector(pauseScanning), userInfo: nil, repeats: false)
        
          centralManager?.scanForPeripherals(withServices: [Constants.SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
    }
    
    @objc private func pauseScanning() {
        // Scanning uses up battery on phone, so pause the scan process for the designated interval.
        print("----- PAUSING SCAN...")
        _ = Timer(timeInterval: timerPauseBeforeNextScanInterval, target: self, selector: #selector(resumeScanning), userInfo: nil, repeats: false)
        centralManager?.stopScan()
    }
    
    @objc private func resumeScanning() {
        if keepScanning {
            print("----- RESUMING SCAN!")
            _ = Timer(timeInterval: timerScanInterval, target: self, selector: #selector(pauseScanning), userInfo: nil, repeats: false)
            centralManager?.scanForPeripherals(withServices: [Constants.SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
}

extension UserDisplayController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatController = ChatController()
        chatController.deviceUUID = visibleDevices[indexPath.row].peripheral.identifier
        chatController.deviceAttributes = visibleDevices[indexPath.row].name
        navigationController?.pushViewController(chatController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleDevices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: peripheralCellId, for: indexPath) as! UserCell
        
        let device = visibleDevices[indexPath.row]
        
        let advertisementData = device.name.components(separatedBy: "|")
        
        cell.advertisementData = advertisementData
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 100
        return height
    }
}

extension UserDisplayController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        //here we scan for the devices with a UUID that is specific to our app, which filters out other BLE devices.
        var state: String?
        switch central.state {
        case .poweredOn:
            
            self.startScanningForBLEDevices()
            
        case .poweredOff:
            state = "Bluetooth on this device is currently powered off."
        case .unsupported:
            state = "This device does not support Bluetooth Low Energy."
        case .unauthorized:
            state = "This app is not authorized to use Bluetooth Low Energy."
        case .resetting:
            state = "The BLE Manager is resetting; a state update is pending."
        case .unknown:
            state = "The state of the BLE Manager is unknown."
        }
        
        if let state = state {
            let alertController = AlertHelper.warn(title: "Bluetooth Problem", message: state)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Here we can read peripheral.identifier as UUID, and read our advertisement data by the key CBAdvertisementDataLocalNameKey.
        
        var peripheralName = cachedPeripheralNames.object(forKey: peripheral.identifier.description as NSString) ?? "unknown"
        
        if let advertisementName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            
            peripheralName = advertisementName as NSString
            cachedPeripheralNames.setObject(peripheralName, forKey: peripheral.identifier.description as NSString)
        }
            
        let device = Device(peripheral: peripheral, name: peripheralName as String)
   
        addOrUpdatePeripheralList(device: device, list: visibleDevices) { (addOrUpdateTuple) in
            if let device = addOrUpdateTuple.0 {
                self.visibleDevices.append(device)
                self.tableView.reloadData()
            }
            
            if let updatedDeviceName = addOrUpdateTuple.1, let updatedDeviceIndex = addOrUpdateTuple.2 {
                self.visibleDevices[updatedDeviceIndex].name = updatedDeviceName
                self.tableView.reloadData()
            }
        }
        
        addOrUpdatePeripheralList(device: device, list: cachedDevices) { (addOrUpdateTuple) in
            if let device = addOrUpdateTuple.0 {
                self.cachedDevices.append(device)
                self.tableView.reloadData()
            }
            
            if let updatedDeviceName = addOrUpdateTuple.1, let updatedDeviceIndex = addOrUpdateTuple.2 {
                self.cachedDevices[updatedDeviceIndex].name = updatedDeviceName
                self.tableView.reloadData()
            }
        }
    }
}

extension UserDisplayController: CBPeripheralManagerDelegate {

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if peripheral.state == .poweredOn {
            updateAdvertisingData()
        }
    }
}
