//
//  BundleToken.swift
//  
//
//  Created by zwc on 2023/2/2.
//

import Foundation

final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
