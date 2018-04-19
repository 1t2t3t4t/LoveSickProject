//
//  userFilter.swift
//  LoveSick2
//
//  Created by marky RE on 19/4/2561 BE.
//  Copyright © 2561 marky RE. All rights reserved.
//

import Foundation

class UserFilter {
    private var minAge:Int!
    private var maxAge:Int!
    private var gender:String!
    private var currentStatus:String!
    init(_ minAge:Int,_ maxAge:Int,_ gender:String,_ currentStatus:String) {
        self.minAge = minAge
        self.maxAge = maxAge
        self.gender = gender
        self.currentStatus = currentStatus
    }
}
