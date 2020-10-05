//
//  File.swift
//  
//
//  Created by Сергей Петрачков on 05.10.2020.
//

import Foundation
import Entities
import Combine

public enum CombineAPI {

  static let provider = CombineRequestExecutor(session: URLSession.shared)
  static let decoder = JSONDecoder()

  public static func getJobs() -> AnyPublisher<[Int], Error> {
    self.provider.run(.jobs(), decoder: decoder).eraseToAnyPublisher()
  }

  public static func postDetails(id: Int) -> AnyPublisher<Post, Error> {
    self.provider.run(.post(id: id), decoder: decoder)
  }

  public static func userDetails(id: String) -> AnyPublisher<User, Error> {
    self.provider.run(.user(id: id), decoder: decoder)
  }
}
