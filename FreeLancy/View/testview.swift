//
//  testview.swift
//  FreeLancy
//
//  Created by Mac Mini 7 on 25/11/2024.
//
import SwiftUI

struct JobsView: View {
    @State private var searchText = ""
    @State private var selectedTab = "Best Matches" // Default selected tab
    let tabs = ["Best Matches", "Most Recent"] // Tab options

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                // Search Bar
                TextField("Search for jobs", text: $searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Tabs for Filtering
                HStack {
                    ForEach(tabs, id: \.self) { tab in
                        Text(tab)
                            .font(.headline)
                            .foregroundColor(selectedTab == tab ? .green : .gray)
                            .onTapGesture {
                                selectedTab = tab
                            }
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom, 5)

                Text("Browse jobs that match your experience to a client's hiring preferences. Ordered by most relevant.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                // Job Listings
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(0..<5, id: \.self) { _ in
                            JobCardView(
                                title: "Beta Test for Google PlayStore",
                                description: "I need 20 beta testers for my app that I want to publish on PlayStore. Android is needed.",
                                tags: ["Android", "Bug Reports", "Usability Testing"],
                                budget: "$5",
                                location: "Sweden",
                                proposals: "20 to 50"
                            )
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()

                // Bottom Navigation Bar
                HStack {
                    NavigationBarItem(icon: "magnifyingglass", title: "Jobs", isActive: true)
                    NavigationBarItem(icon: "pencil", title: "Proposals")
                    NavigationBarItem(icon: "doc.text", title: "Contracts")
                    NavigationBarItem(icon: "message", title: "Messages")
                    NavigationBarItem(icon: "bell", title: "Alerts")
                }
                .padding(.vertical, 10)
                .background(Color.white)
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: -5)
            }
            .navigationTitle("Jobs")
            .navigationBarItems(
                trailing:
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 40, height: 40)
                        .overlay(Text("JD").foregroundColor(.white))
            )
        }
    }
}

// Job Card View for Each Listing
struct JobCardView: View {
    var title: String
    var description: String
    var tags: [String]
    var budget: String
    var location: String
    var proposals: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)

            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)

            // Tags
            HStack {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(5)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(5)
                }
            }

            // Budget, Location, and Proposals
            HStack {
                Text("Budget: \(budget)")
                Spacer()
                Text("Location: \(location)")
                Spacer()
                Text("Proposals: \(proposals)")
            }
            .font(.caption)
            .foregroundColor(.gray)

            Divider()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}

// Bottom Navigation Bar Item
struct NavigationBarItem: View {
    var icon: String
    var title: String
    var isActive: Bool = false

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .foregroundColor(isActive ? .green : .gray)

            Text(title)
                .font(.caption)
                .foregroundColor(isActive ? .green : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}

// Preview
#Preview {
    JobsView()
}

