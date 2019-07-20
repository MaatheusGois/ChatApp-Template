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
    
    //Join Button
    @IBAction func join(_ sender: Any) {
        if let nameOfUser = self.nameUser.text {
            self.socket.emitWithAck("join", nameOfUser).timingOut(after: 1) {
                data in self.performSegue(withIdentifier: "chatMsg", sender: nil)
            }
        }
    }
    
    //ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        socket = manager.defaultSocket
        socket.on(clientEvent: .connect) { data, ack in print("socket connected") }
        socket.connect()
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

}

