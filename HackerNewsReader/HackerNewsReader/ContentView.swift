//
//  ContentView.swift
//  HackerNewsReader
//
//  Created by Сергей Петрачков on 05.10.2020.
//

import SwiftUI
import ModernClient

struct Job {
	let id: Int
}
struct ContentView: View {
	@State private var results = [Job]()
    var body: some View {
		NavigationView() {
			List(results, id: \.id) { item in
				VStack(alignment: .leading) {
					Text("\(item.id)")
						.font(.headline)
//					Text(item.text ?? "no text")
				}
			}.onAppear(perform: self.loadData)
		}
		.navigationBarTitle(Text("Job posts"))
	}

	func loadData() {
		let token = ModernClient.CombineAPI.getJobs().sink(
			receiveCompletion: { error in
				print(error)
			},
			receiveValue: { values in
				self.results = values.map { Job(id: $0) }
			}
		)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
