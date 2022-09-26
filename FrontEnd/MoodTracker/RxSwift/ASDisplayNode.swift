//
//  ASDisplayNode.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/26/22.
//

import Foundation
import AsyncDisplayKit
import UIKit
import RxSwift

public class ASDisplay : ASDisplayNode {
    
    fileprivate var emitTap = PublishSubject<Void>()
    
    public var rxChange : Observable<Void> {
        return emitTap.asObservable()
    }
    
    public override func didLoad() {
        super.didLoad()
//        self.addTarget;(self, action: #selector(tapped()), for: UIControl
//            .valueChanged)
    }
    
    @objc func tapped() {
        emitTap.onNext(())
    }
}
