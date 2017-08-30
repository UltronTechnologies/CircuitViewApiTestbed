//
//  CircuitViewAPI.swift
//  CircuitViewApiTestbed
//
//  Created by Lutrons on 30/08/2017.
//  Copyright © 2017 Lutrons Ltd. All rights reserved.
//


import Foundation
import RxSwift


public protocol CircuitViewAPI {
    // Extend with other API elements as appropriate
    func rooms() -> Observable<CVSchool>
}

