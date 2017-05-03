//
// AsyncResult.swift
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


/**
 Result of an asynchronous operation. 
 
 Asynchronous operations cannot make use of Swift's built-in error handling 
 capabilities, such as `throw`, and so must indicate if they were successful 
 or failed to their completion handlers. Some interfaces use two optional 
 callback parameters to accomplish this: one containing an `Error` if the 
 operation failed, the other containing the successful result. In this case, 
 the documentation usually indicates that only one parameter will be `nil` and 
 the other will always contain a value. 
 
 However, with Swift we can create a callback type to enforce that only an 
 error _or_ a result is returned. This `enum` is that type. 
 */
public enum AsyncResult<T> {

    /** 
     The asynchronous operation completed with success and returned a 
     result of type `T`.
     */
    case success(T)
    
    /**
     The asynchronous operation terminated due to an error encapsulated in the 
     `Error` associated type. 
     */
    case failure(Error)
}
