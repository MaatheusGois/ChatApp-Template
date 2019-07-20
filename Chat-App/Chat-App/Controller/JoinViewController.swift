//
//  ViewController.swift
//  Chat-App
//
//  Created by Matheus Gois on 19/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
// 

import UIKit
import SocketIO

class JoinViewController: UIViewController {
    
    //Manager SocketIO
    let manager = SocketManager(socketURL: URL(string: Server.url)!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    
    //Name TextFild
    @IBOutlet weak var nameUser: UITextField!
    
    //Alert Label
    @IBOutlet weak var alertName: UILabel!
    
    //Join Button
    @IBAction func join(_ sender: Any) {
        if nameUser.text != "" {
            self.showSpinner(onView: self.view)
            if let nameOfUser = self.nameUser.text {
                self.socket.emitWithAck("join", nameOfUser).timingOut(after: 1) {
                    data in
                    self.removeSpinner()
                    self.performSegue(withIdentifier: "chatMsg", sender: nil)
                }
            }
        } else { alertName.isHidden = false }
    }
    
    //ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        socket = manager.defaultSocket
        socket.on(clientEvent: .connect) { data, ack in print("socket connected") }
        socket.connect()
        
        //Remove alert
        setForRemoveAlerts()
        
        //Hide Keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Take editing in textfilds
    func setForRemoveAlerts() {
        nameUser.addTarget(self, action: #selector(nameDidChange(_:)), for: .editingChanged)
    }
    @objc func nameDidChange(_ textField: UITextField) {
        alertName.isHidden = true
    }
    
    //Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != nil {
            if segue.identifier! == "chatMsg" {
                (segue.destination as! ChatViewController).socket = self.socket
                (segue.destination as! ChatViewController).nameOfUser = self.nameUser.text ?? "Sem Nome"
            }
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    //Hide Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

}

