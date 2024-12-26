//
//  StepScreen.swift
//  Jeka
//
//  Created by Wilbert Bryan Wibowo on 29/11/24.
//

import SwiftUI
import Charts

struct StepScreen: View {
    @EnvironmentObject var healthManager: HealthManager
    @State private var progressStep = UserDefaults.standard.object(forKey: "todayStepCount") ?? "0"
    @State private var progressCalorie = UserDefaults.standard.object(forKey: "todayCalories") ?? "0"
    @State private var progressDistance = UserDefaults.standard.object(forKey: "todayDistances") ?? "0"
    @State private var weeklySteps: [Step] = []
    var body: some View {
        ScrollView{
            VStack{
                Text("Your Steps")
                    .bold()
                    .font(.system(size: 45))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 30)
                
                
                Text("Weekly Steps")
                    .bold()
                    .font(.system(size: 32))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 30)
                    .foregroundColor(Color(UIColor(hex:"#B9B9B9")))
                
                Chart {
                    ForEach(weeklySteps) { step in
                        BarMark(
                            x: .value("Day", step.day),
                            y: .value("Steps", step.count)
                        )
                        .foregroundStyle(Color.orange)
                    }
                }
                .frame(height: 200) // Adjust chart height
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            
            // Step
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(UIColor(hex:"#B46617")))
                .frame(width: 350, height: 100)
                .shadow(color: .gray, radius: 5, x: 2, y: 2)
                .overlay(
                    VStack(alignment: .leading){
                        HStack{
                            Image(systemName: "shoeprints.fill")
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                            
                            Text("Step").bold()
                                .foregroundColor(.white)
                                .font(.title)
                        }
                        HStack{
                            Text("\(String(describing: progressStep)) / 10000 Steps")
                                .font(.system(size: 20))
                                .fontWeight(.light)
                                .foregroundColor(.white)
                            
                        } .padding(.top, -10)
                        
                    } .padding(.leading,-120)
                    
                )
            
            // Calories
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(UIColor(hex:"#E76060")))
                .frame(width: 350, height: 100)
                .shadow(color: .gray, radius: 5, x: 2, y: 2)
                .overlay(
                    VStack(alignment: .leading){
                        HStack{
                            Image(systemName: "flame.fill")
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                            
                            Text("Calories").bold()
                                .foregroundColor(.white)
                                .font(.title)
                        }
                        HStack{
                            Text("\(String(describing: progressCalorie)) Kcal")
                                .font(.system(size: 20))
                                .fontWeight(.light)
                                .foregroundColor(.white)
                        } .padding(.top, -10)
                        
                    } .padding(.leading,-120)
                    
                )
            
            // Distances
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(UIColor(hex:"#6D9773")))
                .frame(width: 350, height: 100)
                .shadow(color: .gray, radius: 5, x: 2, y: 2)
                .overlay(
                    VStack(alignment: .leading){
                        HStack{
                            Image(systemName: "location.north.fill")
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                            
                            Text("Distances").bold()
                                .foregroundColor(.white)
                                .font(.title)
                        }
                        HStack{
                            Text("\(String(describing: progressDistance)) m")
                                .font(.system(size: 20))
                                .fontWeight(.light)
                                .foregroundColor(.white)
                            
                        } .padding(.top, -10)
                        
                    } .padding(.leading,-120)
                    
                )
        }
        .onAppear(){
            HealthManager().fetchWeeklySteps { steps in
                    self.weeklySteps = steps
                }
        }
        .onAppear {
            startTimer()
        }
        
    }
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            HealthManager().fetchTodaySteps()
            HealthManager().fetchTodayCalories()
            HealthManager().fetchTodayDistances()
            progressStep = UserDefaults.standard.string(forKey: "todayStepCount") ?? "0"
            progressCalorie = UserDefaults.standard.string(forKey: "todayCalories") ?? "0"
            progressDistance = UserDefaults.standard.string(forKey: "todayDistances") ?? "0"
            print("ini progress step : \(String(describing: progressStep))")
            print("ini progress calories : \(String(describing: progressCalorie))")
            print("ini progress distance : \(String(describing: progressDistance))")
        }
    }
}
struct Step: Identifiable {
    let id = UUID()
    let day: String
    let count: Int
}

#Preview {
    StepScreen()
}
