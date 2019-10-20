//
//  LoginViewController.swift
//  Fyr
//
//  Created by João Raffs on 19/10/19.
//  Copyright © 2019 Joao Raffs. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    var loginExecuter : LoginExecuter = LoginExecuter()
    var databaseRef = Firestore.firestore().collection("users_table")
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBAction func sendButton(_ sender: Any) {
        if let number = phoneNumber.text{
            self.sendsSMS(phoneNumber: number, callback:{
                success in
                if !success{
                    print("o número está errado")
                }else{
                    ModelRaffs.instance.loginExecuter = self.loginExecuter
                    ModelRaffs.instance.phone = number
                    
                    Model.instance.phone = number
                    Model.instance.name = self.nameTextField.text!

                }
        })
            let db = Firestore.firestore().collection("users_table")
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(Model.instance)
                let dict = try JSONSerialization.jsonObject(with: data) as! [String: Any]
                
                db.document(number).setData(dict)
            }catch{
            }
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "MapController")
                   present(vc!, animated: true)
                   self.navigationController?.pushViewController(vc!, animated: true)
        self.changesScreen()
    }
    
    func sendsSMS(phoneNumber: String,callback:@escaping ((Bool) -> ()))
    {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if error != nil {
                print("entrou no error no aprimeiro auth")
                callback(false)
            }else{
                print("entrou no else")
                Model.instance.phone = phoneNumber
                Model.instance.verificationID = String(describing: verificationID!)
                UserDefaults.standard.set(verificationID, forKey: "VerificationID")
                callback(true)
            }
        }
    }
    
    public func changesScreen(){
        let storyboard = UIStoryboard(name: "Second", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VerificationCode") as? ViewController
        performSegue(withIdentifier: "VerificationCode", sender: nil)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
