//
//  URLCache.swift
//  Capstone3
//
//  Created by hastu on 06/11/23.
//

import Foundation

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}
