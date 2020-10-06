//
//  ContentView.swift
//  HackerNewsReader
//
//  Created by Sergey Petrachkov on 05.10.2020.
//

import SwiftUI

struct FeedView: View {

  @ObservedObject var viewModel: FeedViewModel = FeedViewModel()

  var body: some View {
    self.render()
  }

  private func render() -> AnyView {
    switch self.viewModel.state {
    case .initial:
      return AnyView(ProgressView().onAppear(perform: self.loadData))
    case .isLoading:
      return AnyView(ProgressView())
    case .loaded(let jobs):
      return AnyView (
        NavigationView() {
          List(jobs, id: \.id) { item in
            NavigationLink(
              destination: JobDetailsView(id: item.id)
            ) {
                JobRow(id: item.id)
              }
          }
          .navigationBarTitle(Text("Job posts"))
        }
      )
    case .failed(let error):
      return AnyView(
        NavigationView() {
          Text(error.localizedDescription)
            .font(.headline)
        }
        .navigationBarTitle(Text("Job posts"))
      )
    }
  }

  private func loadData() {
    self.viewModel.fetch()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    FeedView()
  }
}
