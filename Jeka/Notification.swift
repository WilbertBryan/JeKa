//
//  Notification.swift
//  Jeka
//
//  Created by student on 22/11/24.
//

import SwiftUI



struct Notification: View {

    @State private var currentPage: Int = 3 // Default to Notifications page

    var body: some View {
        VStack(spacing: 0) {
            // Header Navigation Buttons
            // Main Content Based on Page
            if currentPage == 0 {
                Text("Home Content")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if currentPage == 1 {
                Text("List Content")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if currentPage == 2 {
                Text("QR Code Content")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if currentPage == 3 {
                VStack {
                    // Notifications Header
                    Text("Notifications")
                        .font(.system(size: 45))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 16)
                    // Notification List
                    ScrollView {
                        VStack(spacing: 16) {
                            NotificationCard(
                                title: "You have claimed your voucher",
                                subtitle: "Mcd Voucher",
                                date: "14/11/2025 10:00"
                            )
                            NotificationCard(
                                title: "You got 100 points",
                                subtitle: "",
                                date: "14/11/2025 12:00"
                            )
                            NotificationCard(
                                title: "You got 50 points",
                                subtitle: "",
                                date: "11/11/2025 12:00"
                            )
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
            } else if currentPage == 4 {
                Text("Profile Content")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.bottom)
    }
}



// Notification Card Component

struct NotificationCard: View {
    var title: String
    var subtitle: String
    var date: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.body)
                .fontWeight(.bold)
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Text(date)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}



// Hex Color Extension

#Preview {
    Notification()

}
