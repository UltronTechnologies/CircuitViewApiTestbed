//
//  CircuitViewTypes.swift
//  CircuitViewApiTestbed
//
//  Created by Lutrons on 30/08/2017.
//  Copyright © 2017 Lutrons Ltd. All rights reserved.
//

import Foundation



public enum ApiServiceError : Swift.Error {
    case notImplemented
    case communicationError
    case timeout
    case mappingError
    case itemNotFound
    case custom(error : String)
}

public struct CVLaundryRoom {
    public let location : String
    public let campusName : String
    public let roomName : String
    public let status : String
}

public struct CVSchool {
    public let name : String
    public let rooms : [CVLaundryRoom]
}

