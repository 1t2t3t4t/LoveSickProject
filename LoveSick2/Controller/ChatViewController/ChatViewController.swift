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
        ChatRoomManager.getChatRoom(withUID: self.chatRoom.chatRoomUID!) { (chatroom) in
            chatroom?.messages.removeSubrange(Range(NSRange(location: 0, length: self.chatRoom.messages.count))!)
            self.chatRoom = chatroom
            self.messengerView.delegate?.batchFetchContent!()
            ChatRoomManager.messageListener(withUID: self.chatRoom.chatRoomUID!, completion: { (chat) in
                let textContent = TextContentNode(textMessageString: chat!.message!, currentViewController: self, bubbleConfiguration: self.sharedBubbleConfiguration)
                let newMessage = MessageNode(content: textContent)
                newMessage.cellPadding = self.messagePadding
                let nAvatar = ASImageNode()
                nAvatar.image = #imageLiteral(resourceName: "profileLoad")
                newMessage.currentViewController = self
                newMessage.isIncomingMessage = true
                newMessage.avatarNode = nAvatar
                self.messengerView.addMessage(newMessage, scrollsToMessage: true)
            })
        }
    }
    
    func batchFetchContent() {
        for message in self.chatRoom.messages {
            let textContent = TextContentNode(textMessageString: message.message!, currentViewController: self, bubbleConfiguration: self.sharedBubbleConfiguration)
            let newMessage = MessageNode(content: textContent)
            newMessage.cellPadding = messagePadding
            let nAvatar = ASImageNode()
            nAvatar.image = #imageLiteral(resourceName: "profileLoad")
            newMessage.currentViewController = self
            newMessage.isIncomingMessage = message.senderUID != User.currentUser?.uid!
            newMessage.avatarNode = nAvatar
            self.messengerView.addMessage(newMessage, scrollsToMessage: true)
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
        newMessage.isIncomingMessage = false//isIncomingMessage
        newMessage.avatarNode = nAvatar
        self.messengerView.addMessage(newMessage, scrollsToMessage: true)
        
        self.chatRoom.sendMessage(text)
        return newMessage
    }

}
