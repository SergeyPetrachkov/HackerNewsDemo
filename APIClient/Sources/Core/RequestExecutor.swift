//
//  RequestExecutor.swift
//  
//
//  Created by sergey on 04.10.2020.
//

import Foundation

public protocol RequestExecutor {
  /// Executes an URLRequest and delivers an async result
  ///
  /// - Parameters:
  ///   - urlRequest: The URLRequest to execute
  ///   - completion: A result type containing eiter the response or an error
  func execute(_ urlRequest: URLRequest, completion: @escaping (FlatResult<Response>) -> Void)
}
