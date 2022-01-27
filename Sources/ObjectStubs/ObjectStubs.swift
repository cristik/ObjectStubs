//
// ObjectStubs.swift
//  ObjectStubs
//
//  Created by Cristian Kocza on 26.01.2022.
//


import Foundation

fileprivate var originalIMPs = [Method: IMP]()

enum ObjectStubs {
    static func replace<T: NSObject>(instanceMethod selector: Selector, of cls: T.Type, with body: @escaping (T) -> Void) {
        let method = class_getInstanceMethod(cls, selector)!
        let stub = imp_implementationWithBlock({ body($0 as! T) } as @convention(block) (NSObject) -> Void)
        let originalIMP = method_setImplementation(method, stub)
        if originalIMPs[method] == nil {
            originalIMPs[method] = originalIMP
        }
    }
    
    static func restore() {
        originalIMPs.forEach { method, originalIMP in
            method_setImplementation(method, originalIMP)
        }
        originalIMPs.removeAll()
    }
}
