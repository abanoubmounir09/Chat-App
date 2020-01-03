//
//  ChatViewController.swift
//  testChat
//
//  Created by pop on 1/2/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController {
    var MessageArray : [Message] = []
    @IBOutlet weak var messagetableview: UITableView!
    @IBOutlet weak var sendmessageBTN: UIButton!
    @IBOutlet weak var messageTXTlb: UITextField!
    @IBOutlet weak var heightConstrain: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        messagetableview.delegate = self
        messagetableview.dataSource = self
        messagetableview.separatorStyle = .none
        //UITEXTFIELD: Delgate
        messageTXTlb.delegate = self
        //configrerowhight()
        //ADD: tapGesture to end editing in uitextField
        let tapGestre = UITapGestureRecognizer(target: self, action: #selector(tableviewtapped))
        messagetableview.addGestureRecognizer(tapGestre)
        retrieveMessages()
    }

    @IBAction func LogOutBTNPressed(_ sender: Any) {
        do{
            try FIRAuth.auth()?.signOut()
            navigationController?.popToRootViewController(animated: true)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func sendmessageBtn(_ sender: Any) {
        messageTXTlb.endEditing(true)
        messageTXTlb.isEnabled = false
        sendmessageBTN.isEnabled = false
        let mesageDB = FIRDatabase.database().reference().child("Messages")
        let messageDictionary = ["Sender":FIRAuth.auth()?.currentUser?.email ,"MesageBody":messageTXTlb.text]
        mesageDB.childByAutoId().setValue(messageDictionary){
            (error,reference) in
            if error != nil {
                print("error")
            }else{
                print("message saved successfuly")
                self.messageTXTlb.isEnabled = true
                self.sendmessageBTN.isEnabled = true
                self.messageTXTlb.text = ""
            }
        }
    }
    //MARK: code retrieve data from Firebase
    func retrieveMessages(){
        let MessagesDB = FIRDatabase.database().reference().child("Messages") // to locate specific node
        MessagesDB.observe(.childAdded) {
            (snapshot) in
            let snapshotvalue = snapshot.value as! Dictionary<String,String>
            let messagebody = snapshotvalue["MesageBody"]!
            let sender = snapshotvalue["Sender"]!
            let curmessage = Message()
            curmessage.sender = sender
            curmessage.messagebody = messagebody
            self.MessageArray.append(curmessage)
            self.messagetableview.reloadData()
        }
    }
}//end class


extension ChatViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //configrerowhight()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customMesageCell", for: indexPath)    as? CustomMesageCell else { return UITableViewCell()}
       cell.senderUserName.text = MessageArray[indexPath.row].sender
        cell.messageBody.text = MessageArray[indexPath.row].messagebody
        if cell.senderUserName.text == FIRAuth.auth()?.currentUser?.email as! String{
            cell.avtarimageview.backgroundColor = UIColor.flatMint()
            cell.messagebackground.backgroundColor = UIColor.flatSkyBlue()
            cell.avtarimageview.image = #imageLiteral(resourceName: "im2")
        }else{
            cell.avtarimageview.backgroundColor = UIColor.flatWatermelon()
            cell.messagebackground.backgroundColor = UIColor.flatGray()
            cell.avtarimageview.image = #imageLiteral(resourceName: "im1")
        }
        return cell
    }
    
    func configrerowhight(){
        messagetableview.rowHeight = UITableViewAutomaticDimension
        messagetableview.estimatedRowHeight = 120.0
    }
    
}//end extension


extension ChatViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstrain.constant = 287 //250 keyboard + its height
            self.view.layoutIfNeeded()
        }
       
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstrain.constant = 32 //250 keyboard + its height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func tableviewtapped(){
        messageTXTlb.endEditing(true)
    }
}//end extension

