import SwiftUI
import SwiftData

struct Challenges: View {
    @ObservedObject var pointsModel: PointsModel
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
                        Text("\(pointsModel.points)P").bold()
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
                    ChallengeCard(pointsModel: pointsModel,
                                  title: dailyChallenge[index][0],
                                  totalSteps: Int(dailyChallenge[index][1]) ?? 0,
                                  points: Int(dailyChallenge[index][2]) ?? 0,
                                  backgroundColor: Color.yellow,
                                  pointBackground: Color(hex: "#B36615"),
                                  index: index,
                                  category: "daily"
                    )
                }
            }
            // .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .trailing], 30)
            
            // Weekly Challenges
            Text("Weekly Challenges")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 30)
            
            VStack(spacing: 15) {
                // Weekly Challenge 1 (White with shadow)
                ForEach(0..<weeklyChallenge.count, id: \.self) { index in
                    ChallengeCard(pointsModel: pointsModel,
                                  title: weeklyChallenge[index][0],
                                  totalSteps: Int(weeklyChallenge[index][1]) ?? 0,
                                  points: Int(weeklyChallenge[index][2]) ?? 0,
                                  backgroundColor: Color.yellow,
                                  pointBackground: Color(hex: "#B36615"),
                                  index: index,
                                  category: "weekly"
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .trailing], 30)
            
            Spacer()
        }
        
    }
    
}

struct ChallengeCard: View {
    @ObservedObject var pointsModel: PointsModel
    @EnvironmentObject var healthManager: HealthManager
    @Environment(\.modelContext) private var context
    var title: String
    var totalSteps: Int
    var points: Int
    var backgroundColor: Color
    var pointBackground: Color
    var shadowColor: Color = .clear
    var stepsText: String? = nil
    var isDone: Bool = false
    
    @State private var progressSTEP = UserDefaults.standard.object(forKey: "todayStepCount") as? String ?? "0"
    @State private var progressStep:Int = 0
    
    var index: Int // untuk cek posisi untuk redeeem
    var category: String
    
    @State private var isRedeemed: Bool = false
    
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
        if category == "daily"
        {
            if let tempArray = UserDefaults.standard.array(forKey: "dailyChallengeCheck") as? [Int] {
                // Ensure index is within bounds of the array
                if tempArray[index] == 1 {
                    return Color.gray.opacity(0.1)
                } else {
                    return isChallengeDone ? backgroundColor : Color.gray.opacity(0.2)
                }
            }
        }
        else if category == "weekly"
        {
            if let tempArray = UserDefaults.standard.array(forKey: "weeklyChallengeCheck") as? [Int] {
                if tempArray[index] == 1 {
                    return Color.gray.opacity(0.1)
                } else {
                    return isChallengeDone ? backgroundColor : Color.gray.opacity(0.2)
                }
            }
        }
        return Color.gray.opacity(0.3)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(isChallengeDone ? Color.gray : Color.primary)
                    .frame(maxWidth:.infinity, alignment: .leading)
                
                if (progressStep > totalSteps)
                {
                    Text("\(totalSteps) / \(totalSteps)")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                } else {
                    Text("\(progressStep) / \(totalSteps)")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                }
                
                // DAILY
                if category == "daily" {
                    if let tempArray = UserDefaults.standard.array(forKey: "dailyChallengeCheck") as? [Int] {
                        if tempArray[index] != 1 {
                            if isChallengeDone { //  redeem action disini
                                Button(action: {
                                    isRedeemed = true
                                }) {
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
                                .alert("You got \(points) points.", isPresented: $isRedeemed) {
                                    Button("OK") {
                                        // point nambah
                                        
                                        print("dapet \(points) index ke \(index)")
                                        let newPoint = GetPoints(recievePoints: points)
                                        context.insert(newPoint)
                                        pointsModel.points += points
                                        if var dailyChallengeArray = UserDefaults.standard.array(forKey: "dailyChallengeCheck") as? [Int],
                                           index >= 0 && index < dailyChallengeArray.count {
                                            dailyChallengeArray[index] = 1 // Update the value at the index

                                            UserDefaults.standard.set(dailyChallengeArray, forKey: "dailyChallengeCheck") // Save it back
                                        }
                                        
                                    }
                                }
                            }
                            else {
                                Text("\(points)P")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.gray)
                                    )
                                
                            }
                        }
                    }
                }
                // WEEKLY
                if category == "weekly" {
                    if let tempArray = UserDefaults.standard.array(forKey: "weeklyChallengeCheck") as? [Int] {
                        if tempArray[index] != 1 {
                            if isChallengeDone { //  redeem action disini
                                Button(action: {
                                    isRedeemed = true
                                }) {
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
                                .alert("You got \(points) points.", isPresented: $isRedeemed) {
                                    Button("OK") {
                                        // point nambah
                                        
                                        print("dapet \(points) index ke \(index)")
                                        let newPoint = GetPoints(recievePoints: points)
                                        context.insert(newPoint)
                                        pointsModel.points += points
                                        if var weeklyChallengeArray = UserDefaults.standard.array(forKey: "weeklyChallengeCheck") as? [Int],
                                           index >= 0 && index < weeklyChallengeArray.count {
                                            weeklyChallengeArray[index] = 1 // Update the value at the index
                                            UserDefaults.standard.set(weeklyChallengeArray, forKey: "weeklyChallengeCheck") // Save it back
                                        }
                                        
                                    }
                                }
                            }
                            else {
                                Text("\(points)P")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.gray)
                                    )
                            }
                        }
                    }
                }
                
            }
            //            if let stepsText = stepsText {
            //                Text(stepsText)
            //                    .font(.subheadline)
            //                    .foregroundColor(.gray)
            //            }
            
            if category == "daily"{
                if let tempArray = UserDefaults.standard.array(forKey: "dailyChallengeCheck") as? [Int] {
                    if tempArray[index] == 0 {
                        ProgressView(value: progress, total: 1)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color.red))
                    }
                }
            }
            if category == "weekly"
            {
                if let tempArray = UserDefaults.standard.array(forKey: "weeklyChallengeCheck") as? [Int] {
                    if tempArray[index] == 0 {
                        ProgressView(value: progress, total: 1)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color.red))
                    }
                }
            }
            
                    
        }
        .padding()
        .background(cardBackgroundColor)
        .cornerRadius(10)
        .shadow(color: shadowColor, radius: 5, x: 0, y: 2)
        .onAppear {
            // Clean the string and convert it to an integer when the view appears
            let cleanedString = progressSTEP.replacingOccurrences(of: ",", with: "")
            if let intValue = Int(cleanedString) {
                progressStep = intValue
            } else {
                let cleanedString = progressSTEP.replacingOccurrences(of: ".", with: "")
                if let intValue = Int(cleanedString) {
                    progressStep = intValue
                }
                else{
                    progressStep = 0 // Default to 0 if conversion fails
                    print("fail")
                }
                
            }
        }
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
    Challenges(pointsModel: PointsModel())
}

