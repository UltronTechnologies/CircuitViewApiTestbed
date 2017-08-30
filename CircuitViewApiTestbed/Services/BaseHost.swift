//
//  BaseApiHost.swift
//  orbit-mobile
//
//  Created by Lutrons on 01/06/2017.
//  Copyright © 2017 Lutrons Ltd. All rights reserved.
//

import Foundation


public protocol EndpointProvider {
    var url : String {get}
    func path(withParts p : [String:String]) -> String
}

extension EndpointProvider {
    public func path(withParts p : [String:String]) -> String {
        var targetUrl = self.url
        if p.isEmpty {
            return targetUrl
        }
        
        for pi in p {
            targetUrl = targetUrl.replacingOccurrences(of: pi.key, with: pi.value)
        }
        
        return targetUrl
    }
}


public enum BaseApiHost {
    static let baseHeaders = [
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-API-KEY" : "XX-2-XX"                // TODO replace with the CircuitView API (beta/prod as appropriate)
    ]
    
    static func host(_ ep : EndpointProvider, apiPath api : String? = nil,  withParams p: [String:String] = [:]) -> String {
        let url = ep.path(withParts: p)
        
        // TODO: A bit of a mess - leave in place for now and tidy up later
        if let api = api {
            return api + "/\(url)"
        }
        
        return "XX-1-XX/\(url)" // replace with host URL
    }
}

