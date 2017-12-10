//
//  ViewController.swift
//  BlutoothCom
//
//  Created by David on 09/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class RegiserController: UIViewController, UITextFieldDelegate {
    
    var isUpdateScreen: Bool = false

    lazy var avatarImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "avatar0"))
        iv.layer.cornerRadius = 75
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.layer.borderWidth = 0.5
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAvatarPicking)))
        
        return iv
    }()
    
    let colorButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Pick Your Color", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 3
        button.setTitleColor(UIColor.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleColorPicking), for: .touchUpInside)
        
        return button
    }()
    
    lazy var nameTextField: LeftPaddedTextField = {
        let tf = LeftPaddedTextField()
        tf.placeholder = "Enter name ..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.borderWidth = 0.5
        tf.layer.cornerRadius = 3
        tf.delegate = self
        tf.layer.borderColor = UIColor.lightGray.cgColor
        return tf
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 3
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(handleSaveOfUser), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleSaveOfUser() {
        guard let name = nameTextField.text, !name.isEmpty else {
            let alertController = AlertHelper.warn(title: "Empty Fields", message: "You are missing a value for the name text field ...")
            present(alertController, animated: true, completion: nil)
            return
        }
        
        saveName()
   
        if isUpdateScreen {
            // if display controller first
            navigationController?.popViewController(animated: true)
        } else {
            // if register first
            let userDisplayController = UserDisplayController()
            userDisplayController.navigationItem.hidesBackButton = true 
            navigationController?.pushViewController(userDisplayController, animated: true)
        }
    }
    
    @objc private func handleAvatarPicking() {
        
        let layout = UICollectionViewFlowLayout()
        let avatarPickerContorller = AvatarPickerController(collectionViewLayout: layout)
        navigationController?.pushViewController(avatarPickerContorller, animated: true)
        
    }
    
    @objc private func handleColorPicking() {
        
        let layout = UICollectionViewFlowLayout()
        let colorPickerController = ColorPickerController(collectionViewLayout: layout)
        navigationController?.pushViewController(colorPickerController, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleHideKeyboard)))
        
        navigationItem.title = "Register"
        view.backgroundColor = .white
        
        let userData = UserData()
        isUpdateScreen = userData.hasAllDataFilled
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initData()
    }
    
    func initData() {
        let userData = UserData()
        
        let currentUserAvatar = "\(Constants.kAvatarImagePrefix)\(userData.avatarId)"
        let currentUserColor = Constants.colors[userData.colorId]
        
        avatarImageView.image = UIImage(named: currentUserAvatar)
        view.backgroundColor = currentUserColor
        nameTextField.text = userData.name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nameTextField.resignFirstResponder()
        saveName()
    }
    
    func saveName() {
        var userData = UserData()
        let name = nameTextField.text ?? ""
        userData.name = name
        userData.save()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    @objc private func handleHideKeyboard() {
        self.view.endEditing(true)
    }
    
    private func setupUI() {
        
        view.addSubview(avatarImageView)
        
        
        avatarImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(nameTextField)
        
        nameTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 10).isActive = true
        nameTextField.widthAnchor.constraint(equalToConstant: 250).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(colorButton)
        
        colorButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        colorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        colorButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        colorButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(saveButton)
        
        saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
    
    }
    

}

