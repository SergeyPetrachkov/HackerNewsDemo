//
//  UserViewModel.swift
//  HackerNewsReader
//
//  Created by sergey on 06.10.2020.
//

import Combine
import ModernClient
import Entities

class UserViewModel: ObservableObject {

  private let id: String

  init(id: String) {
    self.id = id
  }

  enum State {
    case initial
    case isLoading(Cancellable)
    case failed(Error)
    case loaded(User)
  }

  @Published private(set) var state = State.initial

  func fetch() {
    self.state = .isLoading(
      CombineAPI.userDetails(id: self.id).sink(
        receiveCompletion: { error in
          print(error)
        },
        receiveValue: { [weak self] value in
          self?.state = .loaded(value)
        }
      )
    )
  }
}
