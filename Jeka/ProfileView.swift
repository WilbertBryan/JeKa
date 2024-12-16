import SwiftUI

struct ProfileView: View {
    @State public var name: String = UserDefaults.standard.string(forKey: "name") ?? "User"
    @State private var navigateToChallenge: Bool = false
    @State private var navigateToStep: Bool = false
    @StateObject private var pointsModel = PointsModel()
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
                        Text("\(name)")
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
                            Text("\(pointsModel.points)P")
                                .font(.headline)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity) // Extend background width
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal) // Add padding to align with the menu
                    
                    // Menu Section
                    VStack(alignment: .leading, spacing: 5) {
                        
                        // Challenge
                        Button(action: {
                            navigateToChallenge = true
                        }) {
                            MenuRow(title: "Challenge")
                        }

                        NavigationLink(destination: Challenges(pointsModel: pointsModel), isActive: $navigateToChallenge) {
                            EmptyView()
                        }
                        
                        // Step
                        Button(action: {
                            navigateToStep = true
                        }) {
                            MenuRow(title: "Step")
                                
                        }
                        NavigationLink(destination: StepScreen(), isActive: $navigateToStep) {
                            EmptyView()

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


                .foregroundColor(.primary)
            

            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
            
        }
        
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
#Preview {
    ProfileView()
}
