//
//  TypeMapping.swift
//  CircuitViewApiTestbed
//
//  Created by Lutrons on 30/08/2017.
//  Copyright © 2017 Lutrons Ltd. All rights reserved.
//

import Foundation


extension CVSchool : ApiResultMapper {
    static func map(fromDict d: Dictionary<String, AnyObject>) -> CVSchool? {
        guard let schoolName = d["schoolName"] as? String ,
            let rooms = d["laundryrooms"] as? [Dictionary<String, AnyObject>]
            else {
                return nil
        }
        
        // for test purposes just ignore rooms which can't be mapped from data.
        let roomlist = rooms.flatMap(CVLaundryRoom.map)
        return CVSchool(name: schoolName, rooms:roomlist)
    }
}

extension CVLaundryRoom : ApiResultMapper {
    static func map(fromDict d: Dictionary<String, AnyObject>) -> CVLaundryRoom? {
        guard let location = d["location"] as? String ,
            let campus = d["campus_name"] as? String,
            let room = d["laundry_room_name"] as? String,
            let status = d["status"] as? String
            else {
                return nil
        }
        
        return CVLaundryRoom(location: location, campusName: campus, roomName: room, status: status)
    }
}

