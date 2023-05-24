//
//  NSObject+.swift
//  Diary of feelings - drop your feelings according to the cloud village
//
//  Created by dan phi on 24/05/2023.
//

import Foundation
protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}
