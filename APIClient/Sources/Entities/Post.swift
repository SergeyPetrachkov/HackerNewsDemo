//
//  Post.swift
//  
//
//  Created by sergey on 04.10.2020.
//

import Foundation

public struct Post: Codable {
  public let id: Int
  public let score: Int
  public let time: Int
  public let type: PostType
  public let by: String
  public let title: String
  public let text: String?
  public let url: String?
}
