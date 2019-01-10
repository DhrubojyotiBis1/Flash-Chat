//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework


class ChatViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{
    
    
    
    // Declare instance variables here
    
    var messageArray = [Message]()

    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.dataSource = self
        messageTableView.delegate = self
    
        
        
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self

        
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        
        messageTableView.addGestureRecognizer(tapGesture)
        
        

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        //TODO: call your configure file here:
        configureTableView()
        
        //TODO: call your retrieveMessages file here:
        retrieveMessages()

        
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell" , for : indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].message
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if messageArray[indexPath.row].email == Auth.auth().currentUser?.email{
            cell.messageBackground.backgroundColor = UIColor.flatRed()
        }else{
            cell.messageBackground.backgroundColor = UIColor.flatGreen()
        }
        
        return cell
    }
    
    
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageArray.count
    }
    
    
    
    
    //TODO: Declare tableViewTapped here:
    
    
    func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    
    
    //TODO: Declare configureTableView here:
    
    func configureTableView(){
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
                self.heightConstraint.constant += 258
                self.view.layoutIfNeeded()
            }
        
    }
    
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
            self.messageTextfield.text = ""
        }
    }
    
    
    //TODO: Declare changeConstrain here:
    

    
    //////////
    /////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        self.sendButton.isEnabled = false
        
        
        //TODO: Send the message to Firebase and save it in our database
        
        let message = ["Email": Auth.auth().currentUser?.email! , "Message" : messageTextfield.text!]
        
        let messageDatabase = Database.database().reference().child("Flash Chat")
        
        messageDatabase.childByAutoId().setValue(message)
        
        messageTextfield.text = ""
        sendButton.isEnabled = true
        
        
        
        
    }
    
    //TODO: Create the retrieveMessages method here:
    func retrieveMessages(){
        let messageDB = Database.database().reference().child("Flash Chat")
        
        messageDB.observe(.childAdded , with: { snapshot in
            
            let message = snapshot.value as! Dictionary<String , String>
            
            let messageObject = Message()
            messageObject.email = message["Email"]!
            messageObject.message = message["Message"]!
            
            self.messageArray.append(messageObject)
            
            self.configureTableView()
            self.messageTableView.reloadData()
            
        })
    }
    
    
    
    
    

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do {
            
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }catch{
            print("Error")
        }
    }

}
