//
//  MapperManager.swift
//  LoveSickProject
//
//  Created by Nathakorn on 1/11/18.
//  Copyright © 2018 Nathakorn. All rights reserved.
//

import Foundation
import ObjectMapper

class MapperManager<Object:Mappable> {
    
    class func mapObject(dictionary:[String:Any]) -> Object {
        return Mapper<Object>().map(JSON: dictionary)!
    }
    
    class func mapObjectArray(array:[[String:Any]]) -> [Object] {
        return Mapper<Object>().mapArray(JSONArray: array)
    }
    
}
