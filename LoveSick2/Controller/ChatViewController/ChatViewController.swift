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

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.inputBarView.textInputAreaView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ChatViewController.sendMessage)))
        
        // Do any additional setup after loading the view.
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


        return newMessage
    }
//    @objc func sendMessage() {
//
////        let textContent = TextContentNode(textMessageString: self.inputBarView.textInputView.text, currentViewController: self, bubbleConfiguration: self.sharedBubbleConfiguration)
////        let newMessage = MessageNode(content: textContent)
////        newMessage.cellPadding = messagePadding
////        let nAvatar = ASImageNode()
////        nAvatar.image = #imageLiteral(resourceName: "profileLoad")
////        newMessage.currentViewController = self
////        newMessage.isIncomingMessage = true
////        print("check for isincoming \(newMessage.isIncomingMessage)")
////        newMessage.avatarNode = nAvatar
////
////        self.messengerView.addMessage(newMessage, scrollsToMessage: true)
//
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
