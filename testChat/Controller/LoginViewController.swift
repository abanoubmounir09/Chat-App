//
//  LoginViewController.swift
//  testChat
//
//  Created by pop on 1/2/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emilTxtlb: UITextField!
    @IBOutlet weak var pasTxtlb: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func lginPresed(_ sender: Any) {
        SVProgressHUD.show()
        FIRAuth.auth()?.signIn(withEmail: emilTxtlb.text!, password: pasTxtlb.text!, completion: {
            (user, error) in
            if error != nil{
                print("error in login")
            }else{
                print("login successful")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "GoToChat", sender: self)
            }
        })
    }
    


}
