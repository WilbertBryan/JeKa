import SwiftUI

struct Challenges: View {
    var body: some View {
        let dailyChallenge: [[String]] = [
            ["Do 1000 steps today!", "1000", "50"],
            ["Do 2000 steps today!", "2000", "100"],
            ["Do 3000 steps today!", "3000", "150"]
        ]
        
        let weeklyChallenge: [[String]] = [
            ["Do 10000 steps this week!", "10000", "300"],
            ["Do 20000 steps this week!", "20000", "500"] ]
        
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
                // Daily Challenge
                ForEach(0..<dailyChallenge.count, id: \.self) { index in
                    ChallengeCard(
                        title: dailyChallenge[index][0],
                        totalSteps: Int(dailyChallenge[index][1]) ?? 0,
                        points: Int(dailyChallenge[index][2]) ?? 0,
                        backgroundColor: Color.yellow,
                        pointBackground: Color(hex: "#B36615")
                    )
                }
                ChallengeCard(
                    title: dailyChallenge[0][0],
                    totalSteps: 0,
                    points: Int(dailyChallenge[0][2]) ?? 0,
                    backgroundColor: Color.yellow,
                    pointBackground: Color(hex: "#B36615"),
                    isDone: true
                )
            }
            // .padding(.horizontal)
            .frame(maxWidth: 340, alignment: .leading)
            .padding(.leading, 30)
            
            // Weekly Challenges
            Text("Weekly Challenges")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 30)
            
            VStack(spacing: 15) {
                // Weekly Challenge 1 (White with shadow)
                ForEach(0..<weeklyChallenge.count, id: \.self) { index in
                    ChallengeCard(
                        title: weeklyChallenge[index][0],
                        totalSteps: Int(weeklyChallenge[index][1]) ?? 0,
                        points: Int(weeklyChallenge[index][2]) ?? 0,
                        backgroundColor: Color.yellow,
                        pointBackground: Color(hex: "#B36615")
                    )
                }
            }
            .frame(maxWidth: 340, alignment: .leading)
            .padding(.leading, 30)
            
            Spacer()
        }
        
    }
    
}

struct ChallengeCard: View {
    var title: String
    var totalSteps: Int
    var points: Int
    var backgroundColor: Color
    var pointBackground: Color
    var shadowColor: Color = .clear
    var stepsText: String? = nil
    var isDone: Bool = false
    var progressStep = Int(UserDefaults.standard.integer(forKey: "todayStepCount"))
    
    // Dynamically determine if the challenge is done
    var isChallengeDone: Bool {
        return progressStep >= totalSteps
    }
    
    var progress: CGFloat {
        // Calculate progress based on steps completed vs total steps
        return CGFloat(progressStep) / CGFloat(totalSteps)
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
                    .frame(maxWidth:.infinity, alignment: .leading)
                
                Text("\(progressStep) / \(totalSteps)")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                Spacer()
                
                // Show points or "DONE"
                //                Text("\(points)P")
                //                    .font(.subheadline)
                //                    .bold()
                //                    .foregroundColor(.gray)
                //                    .padding(8)
                //                    .background(
                //                        RoundedRectangle(cornerRadius: 10)
                //                            .fill(Color.clear)
                //                    )
                if isChallengeDone { //  redeem action disini
                    Text("\(points)P")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(UIColor(hex: "#6D9773")))
                        )
                }
                else {
                    Text("\(points)P")
                        .font(.callout)
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


//struct ChallengeCard: View {
//    var title: String
//    var stepsCompleted: Int
//    var totalSteps: Int
//    var points: Int?
//    var backgroundColor: Color
//    var pointBackground: Color
//    var shadowColor: Color = .clear
//    var stepsText: String? = nil
//    var isDone: Bool = false
//
//    // Dynamically determine if the challenge is done
//    var isChallengeDone: Bool {
//        return stepsCompleted >= totalSteps
//    }
//
//    var progress: CGFloat {
//        // Calculate progress based on steps completed vs total steps
//        return CGFloat(stepsCompleted) / CGFloat(totalSteps)
//    }
//
//    // Background color that changes to gray when done
//    var cardBackgroundColor: Color {
//        isChallengeDone ? Color.gray.opacity(0.3) : backgroundColor
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Text(title)
//                    .font(.headline)
//                    .foregroundColor(isChallengeDone ? Color.gray : Color.primary)
//                Spacer()
//                // Show points or "DONE"
//                if isChallengeDone {
//                    Text("DONE")
//                        .font(.subheadline)
//                        .bold()
//                        .foregroundColor(.gray)
//                        .padding(8)
//                        .background(
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(Color.clear)
//                        )
//                } else if let points = points {
//                    Text("\(points)P")
//                        .font(.subheadline)
//                        .bold()
//                        .foregroundColor(.white)
//                        .padding(8)
//                        .background(
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(pointBackground)
//                        )
//
//                }
//            }
//            if let stepsText = stepsText {
//                Text(stepsText)
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//            ProgressView(value: progress)
//                .progressViewStyle(LinearProgressViewStyle(tint: isChallengeDone ? Color.gray : Color.red))
//        }
//        .padding()
//        .background(cardBackgroundColor)  // Use the conditional background color
//        .cornerRadius(10)
//        .shadow(color: shadowColor, radius: 5, x: 0, y: 2)
//    }
//}

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
