//
//  AsyncArrayExtension.swift
//  ParseriOS
//
//  Source: http://codereview.stackexchange.com/questions/62006/asynchronous-array-map

import Foundation


extension Array {
    // Convenience function which passes the global DISPATCH_QUEUE_PRIORITY_LOW queue as the transformQueue
    public func map<U>(transform: (Element, U -> ()) -> (), withCompletionHandler completionHandler: [U] -> ()) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
        map(transform, onQueue: queue, withCompletionHandler: completionHandler)
    }
    
    public func map<U>(transform: (Element, U -> ()) -> (), onQueue tranformQueue: dispatch_queue_t, withCompletionHandler completionHandler: [U] -> ()) {
        let transformGroup = dispatch_group_create()
        let dataSyncQueue = dispatch_queue_create("array.asyncMap.dataSync", DISPATCH_QUEUE_CONCURRENT)
        var results: [U?] = [U?](count: count, repeatedValue: nil)
        
        // Nested function to dispatch the transform; mainly here to capture index from the for loop below
        func performTransform(index: Int) {
            let item = self[index]
            dispatch_group_enter(transformGroup)
            dispatch_async(tranformQueue) {
                transform(item) {
                    result in
                    dispatch_sync(dataSyncQueue) {
                        results[index] = result
                    }
                    dispatch_group_leave(transformGroup)
                }
            }
        }
        
        for index in (0..<count) {
            performTransform(index)
        }
        
        dispatch_group_notify(transformGroup, tranformQueue) {
            var unwrappedResults: [U]? = nil
            
            // This dispatch_sync doesn't seem to be technically needed since all the transforms should have finished at this point
            dispatch_sync(dataSyncQueue) {
                // Force unwrap the values in the results array
                unwrappedResults = results.map({ item in item! })
            }
            
            completionHandler(unwrappedResults!)
        }
    }
}
