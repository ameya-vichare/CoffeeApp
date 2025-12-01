//
//  IntArrayTransformer.swift
//  Persistence
//
//  Created by Ameya on 05/11/25.
//

import Foundation

@objc(IntArrayTransformer)
final class IntArrayTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool { true }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let arr = value as? [Int] else { return nil }
        return try? JSONEncoder().encode(arr)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        return (try? JSONDecoder().decode([Int].self, from: data)) ?? []
    }
}
