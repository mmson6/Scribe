//
// ErrorObjectDataSource.swift
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
 Wraps an `Error` in an `ObjectDataSource`. 
 
 The data source has one section with one row. Requesting the model at that 
 index path _throws_ the wrapped `Error` object.
 */
final public class ErrorObjectDataSource: ObjectDataSource<Any> {
    public let error: Error
    
    public init(error: Error) {
        self.error = error
        super.init()
    }
    
    override public func numberOfSections() -> Int {
        return 1
    }
    
    override public func numberOfObjects(inSection section: Int) -> Int {
        let count = (section == 0) ? 1 : 0
        return count
    }
    
    override public func object(at indexPath: IndexPath) throws -> Any {
        guard
            indexPath.section == 0,
            indexPath.row == 0
        else {
            throw ObjectDataSourceError.invalidIndexPath(indexPath)
        }
        
        throw self.error
    }
}
