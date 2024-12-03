import SwiftUI

struct ProjectDetailsView: View {
    let project: Projectf
    @ObservedObject var postulationViewModel = PostulationViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(project.title)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Technologies: \(project.technologies)")
                .font(.subheadline)
                .foregroundColor(.blue)

            Text("Description: \(project.description)")
                .font(.body)

            HStack {
                Text("Budget: \(project.budget)")
                    .font(.footnote)
                    .foregroundColor(.green)
                Spacer()
                Text("Deadline: \(project.duration)")
                    .font(.footnote)
                    .foregroundColor(.red)
            }

            Text("Score: \(project.score)%")
                .font(.footnote)
                .foregroundColor(project.score >= 50 ? .green : .red)

            Spacer()

            if postulationViewModel.applicationStatus == "Submitting..." {
                ProgressView("Submitting...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                Button(action: {
                    // Call the ViewModel's function to submit the postulation
                    postulationViewModel.postulate(for: project.id) { success in
                        if success {
                            postulationViewModel.applicationStatus = "Postulation Successful!"
                        } else {
                            postulationViewModel.applicationStatus = "Failed to submit application."
                        }
                    }
                }) {
                    Text("Submit Postulation")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                if !postulationViewModel.applicationStatus.isEmpty {
                    Text(postulationViewModel.applicationStatus)
                        .foregroundColor(postulationViewModel.applicationStatus == "Postulation Successful!" ? .green : .red)
                        .padding()
                }
            }
        }
        .padding()
        .navigationTitle(project.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

