//
//  URLComponentsExtension.swift
//  
//
//  Created by Ryan Westhoelter on 9/22/24.
//

import Foundation

public extension URLComponents {
  
  mutating func setQueryItems(with parameters: [String: String]) {
    self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
  }
}
