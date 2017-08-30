//
//  ApiMappers.swift
//  CircuitViewApiTestbed
//
//  Created by Lutrons on 02/06/2017.
//  Copyright © 2017 Lutrons Ltd. All rights reserved.
//

import Foundation
import RxSwift


protocol ApiResultMapper {
    static func map(fromDict d : Dictionary<String,AnyObject>) -> Self?
}


public enum Either<T,E> {
    case error(e: E)
    case success(v: T)
}


typealias ApiObjectMapper<T> = (Dictionary<String,AnyObject>) -> T?


public enum ApiResultMapperHelper {
    static func mapAll<T>(fromDict d : Dictionary<String,AnyObject>, using m : (Dictionary<String, AnyObject>) -> T?) -> [T] {
        guard let rows = d["rows"] as? Array<Dictionary<String, AnyObject>> else {
            return []
        }
        
        return rows.flatMap(m)
    }
    
    static func mapRows<T>(fromResult result : AnyObject, mapper m : @escaping (Dictionary<String, AnyObject>) -> T?) -> Either<[T],ApiServiceError> {
        guard let dict = result as? Dictionary<String,AnyObject>, let rows = dict["rows"] as? Array<Dictionary<String, AnyObject>> else {
            return Either.error(e: .mappingError)
        }
        
        let result = rows.flatMap(m)
        return Either.success(v: result)
    }
    
    static func mapRow<T>(fromResult result : AnyObject, mapper m : @escaping (Dictionary<String, AnyObject>) -> T?) -> Either<T,ApiServiceError> {
        guard let dict = result as? Dictionary<String,AnyObject>,
            let row = dict["row"] as? Dictionary<String, AnyObject>,
            let item = m(row)
            else {
                return Either.error(e: .mappingError)
        }
        
        
        return Either.success(v: item)
    }
}



extension ObservableType {
    func mapVoid() -> Observable<Void> {
        return flatMap {data -> Observable<Void> in
            return Observable.just(())
        }
    }
    
    func mapObject<T>(_ m: @escaping ApiObjectMapper<T>) -> Observable<T> {
        return flatMap { data -> Observable<T> in
            guard let json = data as? Dictionary<String,AnyObject> else {
                throw NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "ObjectMapper failed to map object"]
                )
            }
            guard let object = m(json) else {
                throw NSError(
                    domain: "",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "ObjectMapper failed to map object"]
                )
            }
            
            return Observable.just(object)
        }
    }
   
    // These are redundant here but let as an example of how mapping could be done.
    
//    func mapRow<T>(_ m: @escaping ApiObjectMapper<T>) -> Observable<T> {
//        return flatMap { data -> Observable<T> in
//            guard let dict = data as? Dictionary<String,AnyObject> else {
//                    throw NSError(
//                        domain: "",
//                        code: -1,
//                        userInfo: [NSLocalizedDescriptionKey: "ObjectMapper failed to map row"]
//                    )
//            }
//
//            guard let object = m(dict) else {
//                throw NSError(
//                    domain: "",
//                    code: -1,
//                    userInfo: [NSLocalizedDescriptionKey: "ObjectMapper failed to map object"]
//                )
//            }
//
//            return Observable.just(object)
//        }
//    }
//
//    func mapOptRow<T>(_ m: @escaping ApiObjectMapper<T>) -> Observable<T?> {
//        return flatMap { data -> Observable<T?> in
//            guard let dict = data as? Dictionary<String,AnyObject>,
//                let row = dict["row"] as? Dictionary<String, AnyObject> else {
//                    return Observable.just(nil)
//            }
//
//            guard let object = m(row) else {
//                throw NSError(
//                    domain: "",
//                    code: -1,
//                    userInfo: [NSLocalizedDescriptionKey: "ObjectMapper failed to map object"]
//                )
//            }
//
//            return Observable.just(object)
//        }
//    }
//
//    func mapArray<T>(_ m: @escaping ApiObjectMapper<T>) -> Observable<[T]> {
//        return flatMap { data -> Observable<[T]> in
//            guard let dict = data as? Dictionary<String,AnyObject>,
//                let rows = dict["rows"] as? Array<Dictionary<String, AnyObject>> else {
//                    throw NSError(
//                        domain: "",
//                        code: -1,
//                        userInfo: [NSLocalizedDescriptionKey: "ObjectMapper failed to map items"]
//                    )
//            }
//
//            let result = rows.flatMap(m)
//            return Observable.just(result)
//        }
//    }
}

