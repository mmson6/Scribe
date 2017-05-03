//
// SPRCommand.swift
// SPRKit
//
// Copyright (c) 2017 SPR Consulting <info@spr.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//

import Foundation


fileprivate let qos = DispatchQoS(qosClass: .userInitiated, relativePriority: -30)


/**
 The AsyncCommand class is an abstract class you use to encapsulate the code 
 and data associated with a task. You do not use this class directly, but 
 instead define a subclass to perform the actual task. Despite being 
 "abstract", the base implementation of `AsyncCommand` includes logic to ensure 
 all of its state updates are thread-safe, that subclasses can easily be 
 written to be thread-safe, and that callbacks will execute on the expected 
 `DispatchQueue`. The presence of this built-in logic allows you to focus on 
 the actual implementation of your task, rather than on the glue code needed to 
 ensure it works correctly with other system objects.
 
 There is a natural comparison to be made between `AsyncCommand` and the 
 `Operation` class in Swift Foundation. The `AsyncCommand` class attempts to be 
 a lighter, easier-to-use alternative to `Operation`. In particular, the
 `Operation` class — due to its long legacy in Objective-C Foundation — is easy 
 to mis-use when subclassing for asynchronous tasks. However, it is possible 
 (and encouraged!) to use `Operation`s to implement the `execute()` method of 
 `AsyncCommand`. 
 */
open class AsyncCommand<T> {
    
    private let privateQueue = DispatchQueue(label: "asynccommand", qos: qos)
    
    private var completionQueue: DispatchQueue?
    private var completionHandler: ((AsyncResult<T>) -> Void)?
    
    private var state: AsyncCommandState<T> = .ready
    
    
    /**
     The result of the command, or `nil` if the command has not completed.
     
     Access to this property is thread-safe. 
     */
    public var result: AsyncResult<T>? {
        get {
            var value: AsyncResult<T>?
            self.privateQueue.sync {
                switch self.state {
                case .completed(let v):
                    value = v
                default:
                    value = nil
                }
            }
            return value
        }
    }
    
    
    // MARK: - Object Life-Cycle
    
    
    /**
     Creates an `AsyncCommand` object.
     */
    public init() {}
    
    
    // MARK: - Public Interface
    
    
    /**
     Called by subclasses when the command has completed successfully to cause 
     the completion handler to be invoked. 
     
     Despite the fact that this method is public, it is _only_ for use by 
     subclasses. 
     
     - Parameter value: The value returned by the command.
     */
    final public func completedWith(value: T) {
        let result = AsyncResult.success(value)
        completedWith(result: result)
    }
    
    /**
     Called by subclasses when the command has terminated due to an error to 
     notify the completion handler.
     
     Despite the fact that this method is public, it is _only_ for use by 
     subclasses. 
     
     - Parameter error: The error that caused the command to terminate.
     */
    final public func completedWith(error: Error) {
        let result = AsyncResult<T>.failure(error)
        completedWith(result: result)
    }
    
    /**
     Begins the execution of the command. 
     
     Performs bookkeeping and then invokes `main()`.
     */
    final public func execute() {
        self.privateQueue.sync {
            assert(self.state.ready)
            
            // update state
            self.state = .running
            
            // perform the work for this command
            DispatchQueue.global(qos: .userInitiated).async {
                // Maintain a strong reference to self so that the command does 
                // not get deallocated during this transition to another queue.
                // Otherwise, it could be deallocated if the caller let the 
                // command object go out of scope after calling execute().
                self.main()
            }
        }
    }
    
    /**
     * Provide a completion handler to be invoked when the command is finished.
     *
     * - Parameter queue: The queue on which the block will be dispatched.
     * - Parameter do: The block to call upon completion of the command.
     */
    final public func onCompletion(
        queue: DispatchQueue = DispatchQueue.main,
        do handler: @escaping (AsyncResult<T>) -> Void
    ) {
        self.privateQueue.sync {
            assert(self.state.ready)
            
            self.completionHandler = handler
            self.completionQueue   = queue
        }
    }
    
    
    // MARK: - Subclass Override Methods
    
    
    /**
     Performs the tasks necessary to carry out the command.
     
     Subclasses override this method to provide the implementation of their
     task. It is expected, but not required, that the implementation performs
     its work on another queue or thread.
     
     Implementations must not call `super.main()` at any time.
     */
    open func main() {
        assert(false, "FATAL: \(type(of: self)) does not override AsyncCommand.main()")
    }
    
    
    // MARK: - Private Helpers
    
    
    final private func completedWith(result: AsyncResult<T>) {
        // Call asynchronously so that if main() is run on the private queue 
        // and synchronously calls the completedWith() methods this does not 
        // dead-lock.
        self.privateQueue.sync {
            assert(self.state.running)
            
            // update state
            self.state = .completed(result)
            
            // call the completion handler on the completion queue
            if let queue = self.completionQueue, let callback = self.completionHandler {
                queue.async {
                    callback(result)
                }
            }
        }
            
    }
}

fileprivate enum AsyncCommandState<T> {
    case ready
    case running
    case completed(AsyncResult<T>)
    
    internal var ready: Bool {
        get {
            let value: Bool
            switch self {
            case .ready:
                value = true
            default:
                value = false
            }
            return value
        }
    }
    
    internal var running: Bool {
        get {
            let value: Bool
            switch self {
            case .running:
                value = true
            default:
                value = false
            }
            return value
        }
    }
    
    internal var completed: Bool {
        get {
            let value: Bool
            switch self {
            case .completed:
                value = true
            default:
                value = false
            }
            return value
        }
    }
}
