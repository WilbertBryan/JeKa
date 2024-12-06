//
//  ContentView.swift
//  Jeka
//
//  Created by student on 19/11/24.
//

import SwiftUI
struct Steps {
    let id: Int
    let title: String
    let image: String
    let amount: String
    
    static let defaultSteps = Steps(id: 0, title: "Step", image: "shoeprints.fill", amount: "0")
}

struct HomeView: View {
    @EnvironmentObject var healthManager: HealthManager
    @State public var point = 1000
    @State public var name = "User"
    @State var steps = Steps.defaultSteps
    @State private var progressStep = UserDefaults.standard.object(forKey: "todayStepCount") ?? "0"

    var body: some View {
        ScrollView{
            VStack {
                HStack{
                    // Text View
                    Text("Hi, \(name)!")
                        .bold()
                        .font(.system(size: 45))
                        .padding(.leading, 30)
                    
                    Spacer()
                    // Point
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color(UIColor(hex: "#6D9773")))
                        .frame(width: 90, height: 34)
                        .overlay(
                            Text("\(point)P").bold()
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .multilineTextAlignment(.center)
                        )
                        .padding(.trailing, 30)
                }
                Image("tree")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 280, height: 280)
                    .clipShape(Circle())
                
                Text("You Save 1 Million Carbons Today !").bold()
                    .font(.system(size: 32))
                    .multilineTextAlignment(.center)
                
                
                // Step
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(UIColor(hex:"#B46617")))
                    .frame(width: 350, height: 100)
                    .shadow(color: .gray, radius: 5, x: 2, y: 2)
                    .overlay(
                        VStack(alignment: .leading){
                            HStack{
                                Image(systemName: steps.image)
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                                
                                Text(steps.title).bold()
                                    .foregroundColor(.white)
                                    .font(.title)
                            }
                            HStack{
                                
                                Text("\(String(describing: progressStep)) / 10000 Steps")
                                    .font(.system(size: 20))
                                    .fontWeight(.light)
                                    .foregroundColor(.white)
                                    .layoutPriority(1)
                                    .lineLimit(1)
                                Image(systemName: "pencil")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                    .opacity(0.7)
                                    .padding(.leading, -10)
                                
                            } .padding(.top, -10)
                            
                        } .padding(.leading,-120)
                    )
                
                // Challenges
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(UIColor(hex:"#FFBA00")))
                    .frame(width: 350, height: 100)
                    .shadow(color: .gray, radius: 5, x: 2, y: 2)
                    .overlay(
                        VStack(alignment: .leading){
                            HStack{
                                Image(systemName: "rosette")
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                                
                                Text("Challenges").bold()
                                    .foregroundColor(.white)
                                    .font(.title)
                            }
                            Text("0 / 5")
                                .font(.system(size: 20))
                                .fontWeight(.light)
                                .foregroundColor(.white)
                                .padding(.top, -10)
                            
                        } .padding(.leading,-120)
                    )
                
                // Quiz
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(UIColor(hex:"#6D9773")))
                    .frame(width: 350, height: 120)
                    .shadow(color: .gray, radius: 5, x: 2, y: 2)
                    .overlay(
                        VStack(alignment: .leading){
                            HStack{
                                Image(systemName: "list.bullet.rectangle")
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                                
                                Text("Quiz").bold()
                                    .foregroundColor(.white)
                                    .font(.title)
                            }
                            Text("Tap for daily quiz and get reward")
                                .font(.system(size:20))
                                .fontWeight(.light)
                                .foregroundColor(.white)
                                .padding(.top, -10)
                            
                        } .padding(.leading,-25)
                    )
            }
        }
        .onAppear {
            startTimer()
        }
    }
    //progress step jalan setiap 3 second
    func startTimer() {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                HealthManager().fetchTodaySteps()
                progressStep = UserDefaults.standard.string(forKey: "todayStepCount") ?? "0"
                print("ini progress : \(String(describing: progressStep))")
            }
        }
}

#Preview {
    HomeView()
}
