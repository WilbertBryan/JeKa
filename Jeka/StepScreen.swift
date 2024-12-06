//
//  StepScreen.swift
//  Jeka
//
//  Created by Wilbert Bryan Wibowo on 29/11/24.
//

import SwiftUI
import Charts

struct StepScreen: View {
    // Sample data for steps
    let stepsData: [Step] = [
        Step(day: "Wed", count: 3000),
        Step(day: "Thu", count: 5000),
        Step(day: "Fri", count: 7000),
        Step(day: "Sat", count: 2000),
        Step(day: "Sun", count: 4000),
        Step(day: "Mon", count: 8000),
        Step(day: "Tue", count: 9000)
    ]
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
                    ForEach(stepsData) { step in
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
                            Text("100 / 10000 Steps")
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
                            Text("100 / 10000 Steps")
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
                            Text("100 / 10000 Steps")
                                .font(.system(size: 20))
                                .fontWeight(.light)
                                .foregroundColor(.white)
                            
                        } .padding(.top, -10)
                        
                    } .padding(.leading,-120)
                    
                )
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
