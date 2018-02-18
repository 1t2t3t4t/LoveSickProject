//
//  VHMessageContentNode.swift
//  LoveSick2
//
//  Created by marky RE on 18/2/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import UIKit
import NMessenger
import AsyncDisplayKit
class VHMessageContentNode: ContentNode {
    
    public var textNode: ASTextNode?
    public var timestampNode: ASTextNode?
    public var attachmentsNode: CollectionViewContentNode?
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let children: [ASLayoutElement?] = [self.timestampNode,
                                            self.textNode,
                                            self.attachmentsNode]
        
        let stackSpec = ASStackLayoutSpec(direction: .vertical,
                                          spacing: 5,
                                          justifyContent: .start,
                                          alignItems: .start,
                                          children: children.flatMap { $0 })
        
        let insets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        
        let insetSpec = ASInsetLayoutSpec(insets: insets,
                                          child: stackSpec)
        return insetSpec
    }
}
