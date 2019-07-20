//
//  ViewController.swift
//  Chat-App
//
//  Created by Matheus Gois on 19/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
// https://github.com/socketio/socket.io-client-swift

import UIKit
import SocketIO

class MainViewController: UIViewController {
    let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    
    
    @IBOutlet weak var nameUser: UITextField!
    
    
    @IBAction func join(_ sender: Any) {
        if let nameOfUser = self.nameUser.text {
            self.socket.emitWithAck("join", nameOfUser).timingOut(after: 1) {
                data in
//                print(data)
//                self.socket?.on("joined", callback: { (data, ack) in
//                    guard let res = data[0] as? Bool else { return }
//                    if res {
//                        
//                    }
//                })
                self.performSegue(withIdentifier: "chatMsg", sender: nil)
            }
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Join"
        socket = manager.defaultSocket
        
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
//            self.socket.emitWithAck("join", "name").timingOut(after: 1) {
//                data in
//                print(data)
//            }
//            socket.emitWithAck("myEvent").timingOut(after: 1) {data in
            
//            }
        }
        
//        socket.on("join") {data, ack in
//            guard let cur = data[0] as? Double else { return }
//
//            socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
//                socket.emit("update", ["amount": cur + 2.50])
//            }
//
//            ack.with("Got your currentAmount", "dude")
//        }
        
        socket.connect()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier != nil {
            if segue.identifier! == "chatMsg" {
                (segue.destination as! ChatViewController).socket = self.socket
                (segue.destination as! ChatViewController).nameOfUser = self.nameUser.text ?? "Sem Nome"
            }
        }
    }


}

