//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD


class RegisterViewController: UIViewController {
    
    

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()

        
        //TODO: Set up a new user on our Firbase database
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            
            if error != nil{
                
                self.errorMessage()
                SVProgressHUD.dismiss()
            }else{
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: nil)
                
            }
            
        }
    }
    func errorMessage(){
        //UIAlartController and UIAlertaction
        let alert = UIAlertController(title: "Failed", message: "Entered email or password is wrong", preferredStyle: .alert)
        let reEnter = UIAlertAction(title: "Enter again", style: .cancel, handler: nil)
        alert.addAction(reEnter)
        self.present(alert,animated: true,completion: nil)
    }
}
