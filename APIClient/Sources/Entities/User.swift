//
//  User.swift
//  
//
//  Created by Сергей Петрачков on 05.10.2020.
//

import Foundation

public struct User: Codable {
  public let id: String
  public let about: String?
  public let karma: Int
  public let submitted: [Int]?
  public let created: Int
}
