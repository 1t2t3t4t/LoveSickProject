//
//  Error.swift
//  LoveSickProject
//
//  Created by Nathakorn on 1/11/18.
//  Copyright © 2018 Nathakorn. All rights reserved.
//

import Foundation

enum LoveSickError: Error {
    
    case PostQueryError
    case UpvoteError
    
}

extension LoveSickError {
    
    var localizedString: String? {
        switch self {
        case .PostQueryError:
            return "There is an error during the post querying"
        case .UpvoteError:
            return "Cannot upvote, Please try again"
        }
    }
    
}
