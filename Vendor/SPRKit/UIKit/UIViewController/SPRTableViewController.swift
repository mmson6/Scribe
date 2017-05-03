//
// SPRTableViewController.swift
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

import UIKit


/**
 Notes: When `loadObjectDataSource(:)` fails, the error is wrapped in an
 `ErrorObjectDataSource` and the table view is reloaded with that data 
 source. On the next tick of the main run loop after the table view was 
 reloaded, the `handleError(:)` method is invoked, allowing subclasses to 
 respond to errors in a more significant manner than just displaying a cell.
 */
open class SPRTableViewController : UITableViewController, SPRViewControllerFSMDelegate {
    
    private var sprvc_fsm = SPRViewControllerFSM()
    private var sprvc_error: Error?
    private var sprvc_objectdatasource: ObjectDataSource<Any>?
    private var sprvc_nextobjectdatasource: ObjectDataSource<Any>?
    private var sprvc_loading = true
    
    public var objectDataSource: ObjectDataSource<Any>? {
        get {
            assert(Thread.current == Thread.main, "SPRTableViewController.objectDataSource can only be accessed on the main queue")
            return self.sprvc_objectdatasource
        }
    }
    
    // MARK: Swift Object
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: UIViewController
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        sprvc_sharedInitialization()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sprvc_sharedInitialization()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.sprvc_loading = (self.sprvc_objectdatasource == nil)
        self.sprvc_fsm.viewDidLoad()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sprvc_fsm.viewWillAppear()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.sprvc_fsm.viewWillDisappear()
    }
    
    // MARK: UITableViewDataSource
    
    final override public func numberOfSections(in tableView: UITableView) -> Int {
        var count: Int?
        if self.sprvc_loading {
            count = 0  // show nothing during first screen load
        } else if let ods = self.sprvc_objectdatasource {
            count = ods.numberOfSections()
        }
        return count ?? 0
    }
    
    final override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        if self.sprvc_loading {
            count = 0  // show nothing during first screen load
        } else if let ods = self.sprvc_objectdatasource {
            count = ods.numberOfObjects(inSection: section)
        }
        return count ?? 0
    }
    
    final override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if let ods = self.sprvc_objectdatasource {
            do {
                let model = try ods.object(at: indexPath)
                cell = renderCell(inTableView: tableView, withModel: model, at: indexPath)
            } catch let e {
                cell = renderCell(inTableView: tableView, withError: e, at: indexPath)
            }
        } else {
            let error = SPRViewControllerError.invalidObjectState
            cell = renderCell(inTableView: tableView, withError: error, at: indexPath)
        }
        
        return cell
    }
    
    // MARK: SPRViewControllerFSMDelegate
    
    final public func showLoading(forFSM fsm: SPRViewControllerFSM) {
        self.sprvc_loading = true
        self.updateViewToShowLoading()
    }
    
    final public func hideLoading(forFSM fsm: SPRViewControllerFSM) {
        self.sprvc_loading = false
        self.updateViewToHideLoading()
    }
    
    final public func loadModel(forFSM fsm: SPRViewControllerFSM, requestID: Int) {
        self.loadObjectDataSource { [weak self] (result) in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                
                switch result {
                case .failure(let error):
                    strongSelf.sprvc_error = error
                    strongSelf.sprvc_nextobjectdatasource = ErrorObjectDataSource(error: error)
                case .success(let ods):
                    strongSelf.sprvc_error = nil
                    strongSelf.sprvc_nextobjectdatasource = ods
                }
                
                fsm.modelLoaded(forRequestID: requestID)
            }
        }
    }
    
    final public func updateView(forFSM: SPRViewControllerFSM) {
        if let nextODS = self.sprvc_nextobjectdatasource {
            self.sprvc_objectdatasource = nextODS
            self.sprvc_nextobjectdatasource = nil
            
            if let tableView = self.tableView {
                tableView.reloadData()
                didReloadTableView(tableView, withObjectDataSource: nextODS)
            }
        }

        if let error = self.sprvc_error {
            DispatchQueue.main.async { [weak self] in
                self?.handleError(error)
            }
        }
    }
    
    // MARK: SPRTableViewController
    
    open func didReloadTableView(_ tableView: UITableView, withObjectDataSource objectDataSource: ObjectDataSource<Any>?) {
        // do nothing
    }
    
    /**
     Called when `loadObjectDataSource(:)` indicates an error occurred. This 
     method may be overridden by subclasses; for example, to show an alert or 
     dismiss themselves.
 
     This method is invoked on the next run loop _after_ the table view
     has been reloaded with the error.
    */
    open func handleError(_ error: Error) {
        // do nothing
    }
    
    open func loadObjectDataSource(_ callback: @escaping (_ result: AsyncResult<ObjectDataSource<Any>>) -> Void) {
        // do nothing
    }
    
    open func renderCell(inTableView tableView: UITableView, withError error: Error, at indexPath: IndexPath) -> UITableViewCell {
        NSLog("FATAL: \(type(of: self)) does not override SPRTableViewController.renderCell(inTableView:withError:at:) or calls super")
        abort()
    }
    
    open func renderCell(inTableView tableView: UITableView, withModel model: Any, at indexPath: IndexPath) -> UITableViewCell {
        NSLog("FATAL: \(type(of: self)) does not override SPRTableViewController.renderCell(inTableView:withModel:at:) or calls super")
        abort()
    }
    
    final public func setNeedsModelLoaded() {
        self.sprvc_fsm.setNeedsModelLoaded()
    }
    
    open func updateViewToShowLoading() {
        // do nothing
    }
    
    open func updateViewToHideLoading() {
        // do nothing
    }
    
    // MARK: Private
    
    private func sprvc_sharedInitialization() {
        self.sprvc_fsm.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(SPRTableViewController.sprvc_handleSetNeedsModelLoaded(notification:)),
            name: SPRViewControllerSetNeedsModelLoadedNotification,
            object: nil
        )
    }
    
    @objc
    private func sprvc_handleSetNeedsModelLoaded(notification: Notification) {
        setNeedsModelLoaded()
    }
    
}
