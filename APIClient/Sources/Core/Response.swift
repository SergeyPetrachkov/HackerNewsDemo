//
//  Response.swift
//  
//
//  Created by sergey on 04.10.2020.
//

import Foundation

public struct Response {
  public let statusCode: StatusCode
  public let data: Data?

  public init(statusCode: StatusCode, data: Data?) {
    self.statusCode = statusCode
    self.data = data
  }
}
