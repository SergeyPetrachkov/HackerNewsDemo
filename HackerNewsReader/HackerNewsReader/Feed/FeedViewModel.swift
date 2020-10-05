//
//  FeedViewModel.swift
//  HackerNewsReader
//
//  Created by sergey on 05.10.2020.
//

import Foundation
import ModernClient
import Combine

struct Job {
  let id: Int
}

class FeedViewModel: ObservableObject {

  enum State {
    case initial
    case isLoading(Cancellable)
    case failed(Error)
    case loaded([Job])
  }

  @Published private(set) var state = State.initial

  func fetch() {
    self.state = .isLoading(
      ModernClient.CombineAPI.getJobs().sink(
        receiveCompletion: { error in
          print(error)
        },
        receiveValue: { [weak self] values in
          self?.state = .loaded(values.map { Job(id: $0) })
        }
      )
    )
  }
}
