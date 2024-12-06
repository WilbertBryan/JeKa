import SwiftUI

struct Challenges: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Text("JEKA Quest")
                    .bold()
                    .font(.system(size: 40))
                    .padding(.leading, 30)
                
                Spacer()
                // Point
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(UIColor(hex: "#6D9773")))
                    .frame(width: 90, height: 34)
                    .overlay(
                        Text("1000P").bold()
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .multilineTextAlignment(.center)
                    )
                    .padding(.trailing, 30)
            }
            
            // Daily Challenges
            Text("Daily Challenges")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 30)

            VStack(spacing: 15) {
                // Daily Challenge 1
                ChallengeCard(
                    title: "Do 10000 steps today !",
                    stepsCompleted:10000,
                    totalSteps: 10000,
                    points: 50,
                    backgroundColor: Color.yellow,
                    pointBackground: Color(hex: "#B36615")
                )

                // Daily Challenge 2 (White with shadow)
                ChallengeCard(
                    title: "Do 1000 steps today !",
                    stepsCompleted: 1000,
                    totalSteps: 1000,
                    points: 50,
                    backgroundColor: Color.white,
                    pointBackground: Color(hex: "#B9B9B9"),
                    shadowColor: Color.gray.opacity(0.5)
                )

                // Completed Challenge (with "DONE")
                ChallengeCard(
                    title: "Welcome to JEKA Quest, where you can collect points when you do your challenges",
                    stepsCompleted: 10000,
                    totalSteps: 10000,
                    points: nil,  // No points as it's done
                    backgroundColor: Color.gray.opacity(0.1),  // This will change based on completion
                    pointBackground: Color.clear,
                    isDone: true
                )
            }
            // .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 30)

            // Weekly Challenges
            Text("Weekly Challenges")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 30)

            VStack(spacing: 15) {
                // Weekly Challenge 1 (White with shadow)
                ChallengeCard(
                    title: "Do 10000 steps !",
                    stepsCompleted: 5000,
                    totalSteps: 10000,
                    points: 50,
                    backgroundColor: Color.yellow,
                    pointBackground: Color(hex: "#B36615"),
                    shadowColor: Color.gray.opacity(0.5)
                )

                // Weekly Challenge 2
                ChallengeCard(
                    title: "Welcome to JEKA Quest, where you can collect points when you do your challenges",
                    stepsCompleted: 0,
                    totalSteps: 10000,
                    points: 50,
                    backgroundColor: Color.gray.opacity(0.1),
                    pointBackground: Color(hex: "#B9B9B9"),
                    isDone: false
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 30)

            Spacer()
        }
    }
}

struct ChallengeCard: View {
    var title: String
    var stepsCompleted: Int
    var totalSteps: Int
    var points: Int?
    var backgroundColor: Color
    var pointBackground: Color
    var shadowColor: Color = .clear
    var stepsText: String? = nil
    var isDone: Bool = false

    // Dynamically determine if the challenge is done
    var isChallengeDone: Bool {
        return stepsCompleted >= totalSteps
    }

    var progress: CGFloat {
        // Calculate progress based on steps completed vs total steps
        return CGFloat(stepsCompleted) / CGFloat(totalSteps)
    }

    // Background color that changes to gray when done
    var cardBackgroundColor: Color {
        isChallengeDone ? Color.gray.opacity(0.3) : backgroundColor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(isChallengeDone ? Color.gray : Color.primary)
                Spacer()
                // Show points or "DONE"
                if isChallengeDone {
                    Text("DONE")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.gray)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.clear)
                        )
                } else if let points = points {
                    Text("\(points)P")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(pointBackground)
                        )
                    
                }
            }
            if let stepsText = stepsText {
                Text(stepsText)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: isChallengeDone ? Color.gray : Color.red))
        }
        .padding()
        .background(cardBackgroundColor)  // Use the conditional background color
        .cornerRadius(10)
        .shadow(color: shadowColor, radius: 5, x: 0, y: 2)
    }
}

// Helper Extension for Hex Colors
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var hexNumber: UInt64 = 0
        scanner.scanHexInt64(&hexNumber)
        let r = Double((hexNumber & 0xFF0000) >> 16) / 255
        let g = Double((hexNumber & 0x00FF00) >> 8) / 255
        let b = Double(hexNumber & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    Challenges()
}
