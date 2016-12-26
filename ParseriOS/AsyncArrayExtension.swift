//
//  AsyncArrayExtension.swift
//  ParseriOS
//
//  Source: http://codereview.stackexchange.com/questions/62006/asynchronous-array-map

import Foundation


extension Array {
    // Convenience function which passes the global DISPATCH_QUEUE_PRIORITY_LOW queue as the transformQueue
    public func map<U>(_ transform: @escaping (Element, (U) -> ()) -> (), withCompletionHandler completionHandler: @escaping ([U]) -> ()) {
        let queue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.low)
        map(transform, onQueue: queue, withCompletionHandler: completionHandler)
    }
    
    public func map<U>(_ transform: @escaping (Element, (U) -> ()) -> (), onQueue tranformQueue: DispatchQueue, withCompletionHandler completionHandler: @escaping ([U]) -> ()) {
        let transformGroup = DispatchGroup()
        let dataSyncQueue = DispatchQueue(label: "array.asyncMap.dataSync", attributes: DispatchQueue.Attributes.concurrent)
        var results: [U?] = [U?](repeating: nil, count: count)
        
        // Nested function to dispatch the transform; mainly here to capture index from the for loop below
        func performTransform(_ index: Int) {
            let item = self[index]
            transformGroup.enter()
            tranformQueue.async {
                transform(item) {
                    result in
                    dataSyncQueue.sync {
                        results[index] = result
                    }
                    transformGroup.leave()
                }
            }
        }
        
        for index in (0..<count) {
            performTransform(index)
        }
        
        transformGroup.notify(queue: tranformQueue) {
            var unwrappedResults: [U]? = nil
            
            // This dispatch_sync doesn't seem to be technically needed since all the transforms should have finished at this point
            dataSyncQueue.sync {
                // Force unwrap the values in the results array
                unwrappedResults = results.map({ item in item! })
            }
            
            completionHandler(unwrappedResults!)
        }
    }
}
