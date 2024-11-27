//
//  SwiftUIView.swift
//  FreeLancy
//
//  Created by Mac Mini 7 on 25/11/2024.
//

import SwiftUI

struct SwiftUIView: View {
    @StateObject private var viewModel = AddProjectViewModel()
    @State private var showProjects = false

    var body: some View {
        VStack {
            Button(action: {
                viewModel.fetchProjects()
                showProjects.toggle()
            }) {
                Text("Show Projects")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            if showProjects {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.projects.isEmpty {
                    Text("No projects found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.projects, id: \.title) { project in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(project.title)
                                .font(.headline)

                            Text(project.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            HStack {
                                Text("Technologies: \(project.technologies)")
                                    .font(.footnote)
                                    .foregroundColor(.blue)
                                Spacer()
                                Text("Budget: \(project.budget)")
                                    .font(.footnote)
                                    .foregroundColor(.green)
                            }

                            Text("Deadline: \(project.duration)")
                                .font(.footnote)
                                .foregroundColor(.red)
                        }
                        .padding()
                    }

                }
            }
        }
        .padding()
    }
}

#Preview {
    SwiftUIView()
}
