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
    
    var nameOfUser = ""
    var socket: SocketIOClient!
    var chat = [Mensage]()
    
    //Chat
    @IBOutlet weak var chatTableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return chat.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if chat[indexPath.row].user == self.nameOfUser {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myChat-msg") as! MyChatCollectionViewCell
            cell.titleMsg.text = chat[indexPath.row].user
            cell.detailMsg.text = chat[indexPath.row].msg
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chat-msg") as! ChatCollectionViewCell
            cell.titleMsg?.text = chat[indexPath.row].user
            cell.detailMsg?.text = chat[indexPath.row].msg
            return cell
        }
    }
    // cells properties and formating
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {return 200}

    //Label of Text
    @IBOutlet weak var msgTextField: UITextField!
    
    //Send Mensage
    @IBAction func sendMsgButton(_ sender: UIButton) {
        guard let msg = msgTextField.text else {return}
        self.socket.emit("send", msg)
        msgTextField.text = ""
    }
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.socket?.on("chat", callback: { (data, ack) in
            guard let user = data[0] as? String else { return }
            guard let msg = data[1] as? String else { return }
            self.chat.append(Mensage(user: user, msg: msg))
            self.chatTableView.reloadData()
        })
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
