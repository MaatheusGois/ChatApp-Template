//
//  ChatViewController.swift
//  Chat-App
//
//  Created by Matheus Gois on 20/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit
import SocketIO

class ChatViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {
    
    var socket: SocketIOClient!
    var nameOfUser:String = ""
    var chat = [Mensage]()
    
    
    
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var msgTextField: UITextField!
    
    @IBAction func sendMsgButton(_ sender: UIButton) {
        guard let msg = msgTextField.text else {return}
        self.socket.emit("send", msg)
        msgTextField.text = ""
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navegation
        self.title = "Chat"
        
        self.socket?.on("chat", callback: { (data, ack) in
            guard let user = data[0] as? String else { return }
            guard let msg = data[1] as? String else { return }
            
            let msgSent = Mensage(user: user, msg: msg)
            self.chat.append(msgSent)
            
            
            self.chatTableView.reloadData()
        })
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if chat[indexPath.row].user == self.nameOfUser {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myChat-msg") as! MyChatCollectionViewCell
            cell.titleMsg.text = chat[indexPath.row].user
            cell.detailMsg.text = chat[indexPath.row].msg
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chat-msg") ?? UITableViewCell()
            cell.textLabel?.text = chat[indexPath.row].user
            cell.detailTextLabel?.text = chat[indexPath.row].msg
            return cell
        }
    }

}
