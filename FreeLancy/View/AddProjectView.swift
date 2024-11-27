import SwiftUI

struct AddProjectView: View {
    @StateObject private var viewModel = AddProjectViewModel() // Use the ViewModel
    
    let statuses = ["To Do", "In Progress", "Completed"] // Possible statuses

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Add a New Project")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)

                        Text("Provide details about the project to attract the best freelancers.")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)

                    // Project Title
                    InputField(
                        icon: "textformat",
                        placeholder: "Project Title",
                        text: $viewModel.projectTitle
                    )

                    // Project Description
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "doc.text")
                                .foregroundColor(.gray)
                            Text("Project Description")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        .padding(.bottom, 5)

                        TextEditor(text: $viewModel.projectDescription)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .frame(height: 120)
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                    }
                    .padding(.horizontal)

                    // Technologies Field
                    InputField(
                        icon: "hammer",
                        placeholder: "Technologies ",
                        text: $viewModel.projectTechnologies
                    )

                    // Project Budget
                    InputField(
                        icon: "dollarsign.circle",
                        placeholder: "Budget (in USD)",
                        text: $viewModel.projectBudget,
                        keyboardType: .decimalPad
                    )

                    // Calendar for Deadline Selection
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.gray)
                            Text("Select Deadline")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        .padding(.bottom, 5)

                        CalendarView(selectedDate: $viewModel.projectDeadline)
                            .frame(height: 300)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                    }
                    .padding(.horizontal)

                    // Project Status Picker
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.gray)
                            Text("Project Status")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        .padding(.bottom, 5)

                        Picker("Select Status", selection: $viewModel.projectStatus) {
                            ForEach(statuses, id: \.self) { status in
                                Text(status).tag(status)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle()) // Segmented Control Style
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                    }
                    .padding(.horizontal)

                    // Error Message
                    if viewModel.showError {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding(.horizontal)
                    }

                    // Submit Button
                    Button(action: {
                        viewModel.submitProject() // Use ViewModel's submit logic
                    }) {
                        HStack {
                            Spacer()
                            if viewModel.isLoading {
                                ProgressView() // Loading spinner
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .foregroundColor(.white)
                            } else {
                                Text("Submit Project")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(viewModel.isLoading ? Color.gray : Color.blue)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        .padding(.horizontal)
                    }
                    .disabled(viewModel.isLoading) // Disable the button during loading

                    Spacer()
                }
                .padding()
            }
            .background(Color(.systemGray6).ignoresSafeArea())
            .navigationTitle("New Project")
        }
    }
}

// MARK: - Calendar View Component
struct CalendarView: View {
    @Binding var selectedDate: Date
    let calendar = Calendar.current
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    var body: some View {
        VStack {
            Text("Selected Date: \(dateFormatter.string(from: selectedDate))")
                .font(.body)
                .foregroundColor(.blue)

            DatePicker(
                "Select Date",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
        }
    }
}

// MARK: - Reusable Input Field Component
struct InputField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                Text(placeholder)
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .padding(.bottom, 5)

            TextField("", text: $text)
                .keyboardType(keyboardType)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview
struct AddProjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddProjectView()
    }
}
