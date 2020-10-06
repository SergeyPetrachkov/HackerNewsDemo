//
//  JobDetailsView.swift
//  HackerNewsReader
//
//  Created by sergey on 06.10.2020.
//

import SwiftUI
import WebKit

struct JobDetailsView: View {

  @ObservedObject var viewModel: PostViewModel

  var body: some View {
    self.render()
  }

  init(id: Int) {
    self.viewModel = PostViewModel(id: id)
  }

  private func render() -> AnyView {
    switch self.viewModel.state {
    case .initial:
      return AnyView(ProgressView().onAppear(perform: self.loadData).onAppear(perform: self.loadData))
    case .isLoading:
      return AnyView(ProgressView())
    case .loaded(let post):
      return AnyView (
        VStack(alignment: .leading, spacing: 4) {
          Text(post.title)
            .font(.body)
          HStack(alignment: .firstTextBaseline) {
            NavigationLink(
              destination: UserView(id: post.by)
            ) {
              Text("by:")
                .font(.system(size: 11, weight: .light, design: .monospaced))
              Text(post.by)
                .font(.system(size: 11, weight: .light, design: .monospaced))
                .foregroundColor(.blue)
            }
            HTMLStringView(htmlContent: post.text ?? "")
          }
        }.padding(16)
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

struct HTMLStringView: UIViewRepresentable {

  let htmlContent: String

  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }

  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.loadHTMLString(htmlContent, baseURL: nil)
  }
}
