//
// SPRViewControllerFSM.swift
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


public protocol SPRViewControllerFSMDelegate: class {
    func showLoading(forFSM fsm: SPRViewControllerFSM) -> Void
    func hideLoading(forFSM fsm: SPRViewControllerFSM) -> Void
    func loadModel(forFSM fsm: SPRViewControllerFSM, requestID: Int) -> Void
    func updateView(forFSM: SPRViewControllerFSM) -> Void
}


public class SPRViewControllerFSM {
    private let queue: DispatchQueue = DispatchQueue(label: "SPRViewControllerFSM", qos: .default)
    private var state: SPRViewControllerState = .hiddenNeedsModelLoaded
    private var currentRequestNumber = 0
    
    public weak var delegate: SPRViewControllerFSMDelegate? = nil
    
    public func viewDidLoad() {
        self.queue.sync {
            switch self.state {
            case .hiddenShowingModel:
                changeState(to: .hiddenNeedsViewUpdated)
            default:
                break
            }
        }
    }
    
    public func viewWillAppear() {
        self.queue.sync {
            switch self.state {
            case .hiddenNeedsModelLoaded:
                changeState(to: .visibleNeedsModelLoaded)
            case .hiddenLoading:
                changeState(to: .visibleLoading)
            case .hiddenNeedsViewUpdated:
                changeState(to: .visibleNeedsViewUpdated)
            case .hiddenShowingModel:
                changeState(to: .visibleShowingModel)
            default:
                break
            }
        }
    }
    
    public func viewWillDisappear() {
        self.queue.sync {
            switch self.state {
            case .visibleLoading:
                changeState(to: .hiddenLoading)
            case .visibleShowingModel:
                changeState(to: .hiddenShowingModel)
            default:
                break
            }
        }
    }
    
    public func setNeedsModelLoaded() {
        self.queue.sync {
            switch self.state {
            case .hiddenLoading:
                changeState(to: .hiddenNeedsModelLoaded)
            case .hiddenNeedsViewUpdated:
                changeState(to: .hiddenNeedsModelLoaded)
            case .visibleLoading:
                changeState(to: .visibleNeedsModelLoaded)
            case .visibleShowingModel:
                changeState(to: .visibleNeedsModelLoaded)
            default:
                break
            }
        }
    }
    
    public func modelLoaded(forRequestID requestID: Int) {
        self.queue.sync {
            guard requestID == self.currentRequestNumber else {
                // ignoring async callback to earlier, "cancelled" loadModel()
                return
            }
            
            switch self.state {
            case .hiddenLoading:
                changeState(to: .hiddenNeedsViewUpdated)
            case .visibleLoading:
                changeState(to: .visibleNeedsViewUpdated)
            default:
                break
            }
        }
    }
    
    private func changeState(to state: SPRViewControllerState) {
        let previousState = self.state
        self.state = state
        
        // if transitioning out of one of the "Loading" states, tell the 
        // delegate to hide the loading indicator
        let loadingStates: [SPRViewControllerState] = [.hiddenLoading, .visibleLoading]
        if loadingStates.contains(previousState) && !loadingStates.contains(state) {
            tellDelegateToHideLoadingIndicator()
        }
        
        // handle delegate calls
        switch state {
        case .visibleLoading:
            tellDelegateToShowLoadingIndicator()
        case .visibleNeedsModelLoaded:
            tellDelegateToLoadModel()
            changeState(to: .visibleLoading)
        case .visibleNeedsViewUpdated:
            tellDelegateToUpdateView()
            changeState(to: .visibleShowingModel)
        default:
            break
        }
    }
    
    private func tellDelegateToHideLoadingIndicator() {
        guard let delegate = self.delegate else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            delegate.hideLoading(forFSM: strongSelf)
        }
    }
    
    private func tellDelegateToLoadModel() {
        guard let delegate = self.delegate else { return }
        
        self.currentRequestNumber += 1
        let requestID = self.currentRequestNumber
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            delegate.loadModel(forFSM: strongSelf, requestID: requestID)
        }
    }

    private func tellDelegateToShowLoadingIndicator() {
        guard let delegate = self.delegate else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            delegate.showLoading(forFSM: strongSelf)
        }
    }
    
    private func tellDelegateToUpdateView() -> Void {
        guard let delegate = self.delegate else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            delegate.updateView(forFSM: strongSelf)
        }
    }
}

fileprivate enum SPRViewControllerState {
    case visibleNeedsModelLoaded
    case visibleLoading
    case visibleNeedsViewUpdated
    case visibleShowingModel
    
    case hiddenNeedsModelLoaded
    case hiddenLoading
    case hiddenNeedsViewUpdated
    case hiddenShowingModel
}
