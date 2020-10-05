//
//  PostViewModel.swift
//  HackerNewsReader
//
//  Created by sergey on 05.10.2020.
//

import ModernClient
import Entities
import Combine

class PostViewModel: ObservableObject {

  enum State {
    case initial
    case isLoading(Cancellable)
    case failed(Error)
    case loaded(Post)
  }

  let id: Int

  init(id: Int) {
    self.id = id
  }

  @Published private(set) var state = State.initial

  func fetch() {
    self.state = .isLoading(
      CombineAPI.postDetails(id: self.id).sink(
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

