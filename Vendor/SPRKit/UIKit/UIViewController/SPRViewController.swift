//
// SPRViewController.swift
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


let SPRViewControllerSetNeedsModelLoadedNotification = Notification.Name("SPRViewControllerSetNeedsModelsLoadedNotification")


public enum SPRViewControllerError: Error {
    case invalidObjectState
}


open class SPRViewController : UIViewController, SPRViewControllerFSMDelegate {
    
    private var sprvc_fsm = SPRViewControllerFSM()
    private var sprvc_result: AsyncResult<Any>? = nil
        
    public var model: Any? {
        get {
            assert(Thread.current == Thread.main, "SPRViewController.model can only be accessed on the main queue")
            
            let value: Any?
            if let result = self.sprvc_result {
                switch result {
                case .success(let v):
                    value = v
                default:
                    value = nil
                }
            } else {
                value = nil
            }
            return value
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
    
    // MARK: SPRViewControllerFSMDelegate
    
    final public func showLoading(forFSM fsm: SPRViewControllerFSM) {
        updateViewToShowLoading()
    }
    
    final public func hideLoading(forFSM fsm: SPRViewControllerFSM) {
        updateViewToHideLoading()
    }

    final public func loadModel(forFSM fsm: SPRViewControllerFSM, requestID: Int) {
        self.loadModel() { [weak self] (result) in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                strongSelf.sprvc_result = result
                fsm.modelLoaded(forRequestID: requestID)
            }
        }
    }
    
    final public func updateView(forFSM: SPRViewControllerFSM) {
        guard let result = self.sprvc_result else { return }
        
        switch result {
        case .failure(let error):
            handleError(error)
        case .success(let model):
            updateView(withModel: model)
        }
    }

    // MARK: SPRViewController
    
    open func handleError(_ error: Error) {
        // do nothing
    }
    
    open func loadModel(_ callback: @escaping (_ result: AsyncResult<Any>) -> Void) {
        // do nothing
    }
    
    open func updateViewToShowLoading() {
        // do nothing
    }
    
    open func updateViewToHideLoading() {
        // do nothing
    }
    
    open func updateView(withModel model: Any) {
        // do nothing
    }
    
    final func setNeedsModelLoaded() {
        self.sprvc_fsm.setNeedsModelLoaded()
    }
    
    // MARK: Private
    
    private func sprvc_sharedInitialization() {
        self.sprvc_fsm.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(SPRViewController.sprvc_handleSetNeedsModelLoaded(notification:)),
            name: SPRViewControllerSetNeedsModelLoadedNotification,
            object: nil
        )
    }
    
    @objc
    private func sprvc_handleSetNeedsModelLoaded(notification: Notification) {
        self.setNeedsModelLoaded()
    }
    
}

