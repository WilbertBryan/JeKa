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
                                .foregroundColor(.black) // Change color to black
                        }

                        NavigationLink(destination: Text("Quiz View")) {
                            MenuRow(title: "Quiz")
                                .foregroundColor(.black) // Change color to black
                        }

                        NavigationLink(destination: Text("Step View")) {
                            MenuRow(title: "Step")
                                .foregroundColor(.black) // Change color to black
                        }

                        NavigationLink(destination: Text("Change Password View")) {
                            MenuRow(title: "Change Password")
                                .foregroundColor(.black) // Change color to black
                        }
                    }
                    .padding(.horizontal)

                    // Move Logout Button Up
                    Button(action: {
                        print("Logout tapped")
                    }) {

                        Text("Logout")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 10) // Smaller vertical padding
                            .padding(.horizontal, 45) // Adjusted horizontal padding for a compact look
                            .background(Color.yellow)
                            .cornerRadius(20) // Rounded rectangle

                    }

                    .padding(.top, 10) // Added padding to move the button upwards
                    .padding(.horizontal) // Add horizontal padding for better spacing
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
                .foregroundColor(.black) // Ensure text color is black

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)

        }

        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
//#Preview {
//    ProfileView()
//}
