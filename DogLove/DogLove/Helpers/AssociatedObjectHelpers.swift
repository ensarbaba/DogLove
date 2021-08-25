//
//  AssociatedObjectHelpers.swift
//  DogLove
//
//  Created by M. Ensar Baba on 11.06.2021.
//

import Foundation

func associatedObject<ObjectType: Any>(base: Any, key: UnsafePointer<UInt8>, initialValue: ObjectType? = nil) -> ObjectType? {
    if let associated = objc_getAssociatedObject(base, key) as? ObjectType { return associated }
    if let initialValue = initialValue {
        objc_setAssociatedObject(base, key, initialValue, .OBJC_ASSOCIATION_RETAIN)
    }
    return initialValue
}

func associateObject<ObjectType: Any> (base: Any, key: UnsafePointer<UInt8>, value: ObjectType?) {
    objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
}
