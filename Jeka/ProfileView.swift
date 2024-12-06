//
//  ProfileView.swift
//  Jeka
//
//  Created by student on 22/11/24.
//

import SwiftUI

struct ProfileView: View {

    var body: some View {
        NavigationView {
            VStack(spacing:20) {
                // Custom Header
                HStack {
                    Text("Profile")
                        .font(.system(size: 45)) // Increase the font size here
                        .fontWeight(.bold) // Optional: Make the font weight bold
                    Spacer()
                }
                .padding()
                
                ScrollView {
                    // Profile Picture and Greeting
                    VStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 130, height: 130) // Increased size
                            .clipShape(Circle())
                            .padding()
                        Text("Change Picture")
                            .font(.footnote)
                            .foregroundColor(.black) // Changed from blue to black
                        Text("Hi User")
                            .font(.largeTitle)
                            .fontWeight(.medium)
                    }
                    // Voucher and Points Section
                    HStack(spacing: 75) {
                        VStack {
                            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                .font(.largeTitle)
                            Text("Voucher")
                            Text("150")
                                .font(.headline)
                        }
                        Divider()
                            .frame(height: 75)
                        VStack {
                            Image(systemName: "star.fill")
                                .font(.largeTitle)
                            Text("Point")
                            Text("1500P")
                                .font(.headline)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity) // Extend background width
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal) // Add padding to align with the menu

                    // Menu Section
                    VStack(alignment: .leading, spacing: 10) {
                        NavigationLink(destination: Text("Challenge View")) {
                            MenuRow(title: "Challenge")
                        }

                        NavigationLink(destination: Text("Quiz View")) {
                            MenuRow(title: "Quiz")
                                
                        }

                        NavigationLink(destination: Text("Step View")) {
                            MenuRow(title: "Step")
                                
                        }

                        NavigationLink(destination: Text("Change Password View")) {
                            MenuRow(title: "Change Password")
                            
                        }
                    }
                    .padding(.horizontal)

                }
                .navigationBarHidden(true) // Hide default navigation bar title
                }
        }
        
            
    }
}



struct MenuRow: View {
    let title: String
    var body: some View {

        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary) // Ensure text color is black

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)

        }

        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
#Preview {
    ProfileView()
}
