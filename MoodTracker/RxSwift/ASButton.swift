//
//  ASButton.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/25/22.
//

import Foundation

import AsyncDisplayKit
import RxSwift

public class ASButton : ASButtonNode {
    
    fileprivate var emitTap = PublishSubject<Void>()
    
    public var rxTap : Observable<Void> {
        return emitTap.asObservable()
    }
    
    public override func didLoad() {
        super.didLoad()
        self.addTarget(self, action: #selector(tapped), forControlEvents: .touchUpInside)
    }
    
    @objc func tapped() {
        emitTap.onNext(())
    }
}
