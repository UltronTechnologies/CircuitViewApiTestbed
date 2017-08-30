//
//  CircuitViewServiceHost.swift
//  CircuitViewApiTestbed
//
//  Created by Lutrons on 30/08/2017.
//  Copyright © 2017 Lutrons Ltd. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire


public enum ApiEndpoints {
    case rooms
}

extension ApiEndpoints : EndpointProvider {
    // This can be extended as required
    public var url: String {
        switch self {
        case .rooms : return "school/rooms"
        }
    }
}

public struct CircuitViewServiceHost : CircuitViewAPI {
    public static let apikey = "XX-3-XX"   // TODO replace this value with your API key
    
    public func rooms() -> Observable<CVSchool> {
        return json(.get, BaseApiHost.host(ApiEndpoints.rooms), parameters: ["api_key":CircuitViewServiceHost.apikey], headers: BaseApiHost.baseHeaders)
                    .mapObject(CVSchool.map)
    }
    
}
