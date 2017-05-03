//
// MappingObjectDataSource.swift
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
 The MappingObjectDataSource class is an ObjectDataSource that wraps another 
 ObjectDataSource and performs a transformation on the objects returned by that 
 data source. 
 
 This adapter is useful for converting domain model objects into view-model 
 objects. This class is commonly applied in cases where the technology storing
 the domain model provides high-performance or low-memory operation (e.g., 
 NSFetchedResultsController), but the domain model objects need to be 
 transformed into view-models for use by the View layer of the application. 
 */
public class MappingObjectDataSource<T,U>: ObjectDataSource<U> {
    /**
     Function that converts an object of type `T` into an object of type `U`.
     
     - Parameter obj: Object to mapped.
          
     - Throws: 
       - Error if the object could not be mapped.
     
     - Returns: An object derived from the object passed as a parameter.
     */
    public typealias MapFunction = (_ obj: T) throws -> U
    
    private let wrappedODS: ObjectDataSource<T>
    private let map: MapFunction
    
    /**
     Create a MappingObjectDataSource that transforms the objects of type `T` 
     returned by the underlying ObjectDataSource into objects of type `U`.
     
     - Parameter objectDataSource: ObjectDataSource providing objects to be 
       transformed by this class. 
     - Parameter map: Function that transforms an object of type `T` into an 
       object of type `U`. 
     */
    public init(objectDataSource: ObjectDataSource<T>, map: @escaping MapFunction) {
        self.wrappedODS = objectDataSource
        self.map = map
        
        super.init()
    }
    
    // MARK: ObjectDataSource
    
    public override func name(ofSection section: Int) -> String? {
        return self.wrappedODS.name(ofSection: section)
    }
    
    public override func numberOfObjects(inSection section: Int) -> Int {
        return self.wrappedODS.numberOfObjects(inSection: section)
    }
    
    public override func numberOfSections() -> Int {
        return self.wrappedODS.numberOfSections()
    }
    
    public override func object(at indexPath: IndexPath) throws -> U {
        let srcObj = try self.wrappedODS.object(at: indexPath)
        let dstObj = try self.map(srcObj)
        return dstObj
    }
    
}
