//
//  ChatController.swift
//  BlutoothCom
//
//  Created by David on 11/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import CoreBluetooth

class ChatController: UIViewController {
    
    let chatMessageCellId = "chatMessageCellId"
    
    var deviceUUID: UUID? = nil
    var deviceAttributes : String = ""
    
    var selectedPeripheral : CBPeripheral?
    var centralManager: CBCentralManager?
    var peripheralManager = CBPeripheralManager()
    
    var messages = [Message]()
    
    lazy var messagesTableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    lazy var bottomInputContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.placeholder = "Type message here..."
        return tf
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    let dividerLine: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.estimatedRowHeight = 68
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        
        messagesTableView.register(ChatMessageCell.self, forCellReuseIdentifier: chatMessageCellId)
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        setupUI()
        registerForKeyboardNotifs()
        
    }
    
    var bottomInputContaierBottomAnchor: NSLayoutConstraint?
    
    fileprivate func setupUI() {
        
        navigationController?.navigationBar.barTintColor = .red
        messagesTableView.separatorColor = .clear
        
        view.addSubview(messagesTableView)
        
        messagesTableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, topPadding: 0, leadingPadding: 0, bottomPadding: 50, trailingPadding: 0, width: 0, height: 0)
        
        view.addSubview(bottomInputContainerView)
        
        
        bottomInputContaierBottomAnchor = bottomInputContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        bottomInputContaierBottomAnchor?.isActive = true
        
        bottomInputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        bottomInputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        bottomInputContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        view.addSubview(sendButton)

        sendButton.anchor(top: bottomInputContainerView.topAnchor, leading: nil, bottom: bottomInputContainerView.bottomAnchor, trailing: bottomInputContainerView.trailingAnchor, topPadding: 0, leadingPadding: 0, bottomPadding: 0, trailingPadding: 5, width: 40, height: 0)
        
        view.addSubview(inputTextField)
        
        inputTextField.anchor(top: bottomInputContainerView.topAnchor, leading: bottomInputContainerView.leadingAnchor, bottom: bottomInputContainerView.bottomAnchor, trailing: sendButton.leadingAnchor, topPadding: 0, leadingPadding: 6, bottomPadding: 0, trailingPadding: 0, width: 0, height: 0)
        
        view.addSubview(dividerLine)
        
        dividerLine.anchor(top: nil, leading: bottomInputContainerView.leadingAnchor, bottom: bottomInputContainerView.topAnchor, trailing: bottomInputContainerView.trailingAnchor, topPadding: 0, leadingPadding: 0, bottomPadding: 0, trailingPadding: 0, width: 0, height: 0.5)

        setupChatPartnerSpecificUI()
    }
    
    private func setupChatPartnerSpecificUI() {
        let deviceData = deviceAttributes.components(separatedBy: "|")
        
        navigationItem.title = deviceData[0]
        
        if deviceData.count > 2 {
            if let deviceIndex = Int(deviceData[2]) {
                  navigationController?.navigationBar.barTintColor = Constants.colors[deviceIndex]
            }
        }
    }
    
    private func registerForKeyboardNotifs() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc private func keyboardWillBeShown(notification: NSNotification) {
        animateViewMoving(up: true, notification: notification, resigningFirstResponderStatus: false)
    }
    
    @objc private func keyboardWillBeHidden(notification: NSNotification) {
        animateViewMoving(up: false, notification: notification, resigningFirstResponderStatus: false)
    }
    
    private func animateViewMoving(up: Bool, notification: NSNotification?, resigningFirstResponderStatus: Bool) {
        let durationOfMovement = 0.2
        var movement:CGFloat = 0
        
        if !resigningFirstResponderStatus {
            guard let notification = notification else { return }
            if let info = notification.userInfo {
                let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
                let moveValue = keyboardSize?.height ?? 0
                movement = (up ? -moveValue : moveValue)
            }
        }
        
        UIView.animate(withDuration: durationOfMovement, animations: {
            self.bottomInputContaierBottomAnchor?.constant = movement
        }, completion: nil)
    }
    
    @objc private func handleSend() {
        if !((inputTextField.text?.isEmpty)!) {
            guard let selecterPeripheral = selectedPeripheral else { return }
            centralManager?.connect(selecterPeripheral, options: nil)
            inputTextField.resignFirstResponder()
            animateViewMoving(up: false, notification: nil, resigningFirstResponderStatus: true)
        }
    }
    
    func appendMessageToChat(message: Message) {
        
        messages.append(message)
        messagesTableView.reloadData()
    }
    
    private func setupService() {
        
        let serialService = CBMutableService(type: Constants.SERVICE_UUID, primary: true)
        let writableCharacteristics = CBMutableCharacteristic(type: Constants.WR_UUID, properties: Constants.WR_PROPERTIES, value: nil, permissions: Constants.WR_PERMISSIONS)
        serialService.characteristics = [writableCharacteristics]
        
        peripheralManager.add(serialService)
    }
    
    func updateAdvertisingData() {
        
        if (peripheralManager.isAdvertising) {
            peripheralManager.stopAdvertising()
        }
        
        let userData = UserData()
        let advertisementData = "\(userData.name)|\(userData.avatarId)|\(userData.colorId)"
        
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[Constants.SERVICE_UUID], CBAdvertisementDataLocalNameKey: advertisementData])
        
    }
    
    deinit {
        deregisterFromKeyboardNotifications()
    }
    
    private func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

extension ChatController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: chatMessageCellId, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.row]
        
        cell.message = message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

extension ChatController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        animateViewMoving(up: false, notification: nil, resigningFirstResponderStatus: true)
        return true
    }
}

extension ChatController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: [Constants.SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripheral.identifier == deviceUUID {
            
            selectedPeripheral = peripheral
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        peripheral.delegate = self
        // passing nil means discover all services on peripheral
        peripheral.discoverServices(nil)
        
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print("Failed to connect to peripheral: \(error)")
        }
    }
}

extension ChatController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error when discovering services \(error)")
            return
        }
        guard let services = peripheral.services else { return }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let error = error {
            print("Error discovering characteristics of service: \(error)")
            return
        }
        
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            
            if characteristic.uuid == Constants.WR_UUID {
                if let messageText = inputTextField.text {
                    if let messageData = messageText.data(using: .utf8) {
                        peripheral.writeValue(messageData, for: characteristic, type: .withResponse)
                        let message = Message(text: messageText, isSent: true)
                        appendMessageToChat(message: message)
                        inputTextField.text = ""
                    }
                }
            }
        }
    }
}

extension ChatController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        switch peripheral.state {
            case .poweredOn:
                setupService()
                updateAdvertisingData()
                break
            default:
                print("Peripheral not in .powerOn state")
                break
        }
//        if peripheral.state == .poweredOn {
//            setupService()
//            updateAdvertisingData()
//        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        
        for request in requests {
            if let value = request.value {
                //here is the message text that we received
                if let messageText = String(data: value, encoding: .utf8) {
                    let message = Message(text: messageText, isSent: false)
                    appendMessageToChat(message: message)
                }
            }
            self.peripheralManager.respond(to: request, withResult: .success)
        }
    }
}










