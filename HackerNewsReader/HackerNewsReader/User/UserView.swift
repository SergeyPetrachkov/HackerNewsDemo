//
//  UserView.swift
//  HackerNewsReader
//
//  Created by sergey on 06.10.2020.
//

import SwiftUI

struct UserView: View {

  @ObservedObject var viewModel: UserViewModel

  var body: some View {
    self.render()
  }

  init(id: String) {
    self.viewModel = UserViewModel(id: id)
  }

  private func render() -> AnyView {
    switch self.viewModel.state {
    case .initial:
      return AnyView(ProgressView().onAppear(perform: self.loadData).onAppear(perform: self.loadData))
    case .isLoading:
      return AnyView(ProgressView())
    case .loaded(let user):
      return AnyView (
        HStack {
          Text(user.id)
        }
      )
    case .failed(let error):
      return AnyView(
        Text(error.localizedDescription)
          .font(.headline)
      )
    }
  }

  private func loadData() {
    self.viewModel.fetch()
  }
}

