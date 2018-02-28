//
//  ChatViewController.swift
//  LoveSick2
//
//  Created by marky RE on 18/2/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import NMessenger
import AsyncDisplayKit

class ChatViewController: NMessengerViewController {
    
    var chatRoom:ChatRoom!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
         self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = chatRoom.userUID
        ChatRoomManager.getChatRoom(withUID: chatRoom.chatRoomUID!) { (chatroom) in
            self.chatRoom = chatroom
            self.viewWillLayoutSubviews()
        }
        
    }
    override func sendText(_ text: String, isIncomingMessage: Bool) -> GeneralMessengerCell {
        //create a new text message
        let textContent = TextContentNode(textMessageString: text, currentViewController: self, bubbleConfiguration: self.sharedBubbleConfiguration)
        let newMessage = MessageNode(content: textContent)
        newMessage.cellPadding = messagePadding
        let nAvatar = ASImageNode()
        nAvatar.image = #imageLiteral(resourceName: "profileLoad")
        newMessage.currentViewController = self
        print("check check 156789 \(isIncomingMessage)")
        newMessage.isIncomingMessage = false//isIncomingMessage
        newMessage.avatarNode = nAvatar
        self.messengerView.addMessage(newMessage, scrollsToMessage: true)
        
        self.chatRoom.sendMessage(text)
        return newMessage
    }

}
