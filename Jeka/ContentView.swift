//
//  ContentView.swift
//  Jeka
//
//  Created by student on 19/11/24.
//

import SwiftUI

import Foundation

func isNewDay(from date: Date?) -> Bool {
    guard let date = date else { return true }
    let calendar = Calendar.current
    return !calendar.isDateInToday(date)
}
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
        
        @State public var name: String = UserDefaults.standard.string(forKey: "name") ?? "User"
        @State private var isQuizComplete = false
        @State private var showAlert = false
        @State private var navigateToQuiz = false
        @State private var targetStep = 10000
        @State private var progressStep = UserDefaults.standard.object(forKey: "todayStepCount") ?? "0"
        // for step
        @State private var isEditing: Bool = false // Controls the popup visibility
        @State private var inputText: String = ""
        @State private var checkError: Bool = false
        @State private var navigateToStep: Bool = false
        @State var steps = Steps.defaultSteps
        
        // for name
        @State private var inputName: String = ""
        @State private var noName: Bool = false
        
        // for challenge
        @State private var navigateToChallenge: Bool = false
        
        var body: some View {
            NavigationView{
                //            ScrollView{
                //            if name != "User" {
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
                    ScrollView {
                        Image("tree")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 280, height: 280)
                            .clipShape(Circle())
                        
                        Text("You've Saved 1 Million Carbons Today !").bold()
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
                                        Image(systemName: "shoeprints.fill")
                                            .font(.system(size: 25))
                                            .foregroundColor(.white)
                                        
                                        Text("Step").bold()
                                            .foregroundColor(.white)
                                            .font(.title)
                                    }
                                    HStack{
                                        Text("\(String(describing: progressStep)) / \(targetStep) steps")
                                            .font(.system(size: 20))
                                            .fontWeight(.light)
                                            .foregroundColor(.white)
                                        Button(action: {
                                            isEditing = true // Show the popup
                                            inputText = "\(targetStep)" // Pre-fill with current value
                                        }){
                                            Image(systemName: "pencil")
                                                .font(.system(size: 15))
                                                .foregroundColor(.white)
                                                .opacity(0.7)
                                                .padding(.leading, -5)
                                        }  .alert("Change your target steps", isPresented: $isEditing) {
                                            TextField("Enter Step",  text: $inputText)
                                                .keyboardType(.numberPad)
                                            Button("OK") {
                                                let temp = Int(inputText) ?? 0
                                                if inputText == "" || temp <= 0 {
                                                    // kasih alert
                                                    print("Error")
                                                }
                                                else
                                                {
                                                    targetStep = temp
                                                }
                                            }
                                        }
                                    } .padding(.top, -10)
                                } .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 30)
                            )
                            .padding(.bottom, 10)
                        
                        
                        // Challenges
                        Button(action: {
                            navigateToChallenge = true
                        }) {
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
                                            
                                            Text("Challenge").bold()
                                                .foregroundColor(.white)
                                                .font(.title)
                                        }
                                        Text("0 / 5")
                                            .font(.system(size: 20))
                                            .fontWeight(.light)
                                            .foregroundColor(.white)
                                            .padding(.top, -10)
                                        
                                    } .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 30)
                                )
                                .padding(.bottom, 10)
                        }
                        NavigationLink(destination: Challenges(), isActive: $navigateToChallenge) {
                            EmptyView()
                        }
                        
                        // Quiz
                        
                        Button(action: {
                            if isQuizComplete {
                                showAlert = true // Show alert if quiz is complete
                            } else {
                                navigateToQuiz = true // Navigate if quiz is not complete
                            }
                        }) {
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
                                        
                                    } .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 30)
                                )
                                .padding(.bottom, 10)
                        }
                        NavigationLink(destination: Quiz(isQuizComplete: $isQuizComplete), isActive: $navigateToQuiz) {
                            EmptyView()
                        }
                    }
                    
                    .alert("You've already completed the quiz for today!", isPresented: $showAlert) {
                        Button("OK", role: .cancel) {}
                    }
                }            .scrollIndicators(.hidden) // Hide the scroll bar
                
                //  }
                
                // }
            }
            
            .alert("Enter your name", isPresented: $noName) {
                TextField("Your name", text: $inputName)
                    .keyboardType(.default)
                Button("OK") {
                    if inputName == ""{
                        // kasih alert
                        print("Error")
                    }
                    else
                    {
                        print("inputName")
                        UserDefaults.standard.set(inputName, forKey: "name")
                        name = inputName
                        noName = false
                    }
                }
            }
            .onAppear(perform : checkDailyReset) // krna ini
            .onAppear {
                if UserDefaults.standard.string(forKey: "name")?.isEmpty ?? true {
                    noName = true
                }
            }
            
        }
        
        
        private func checkDailyReset() {
            let lastCompletionDate = UserDefaults.standard.object(forKey: "LastQuizCompletionDate") as? Date
            print(lastCompletionDate)
            if isNewDay(from: lastCompletionDate) {
                isQuizComplete = false
            } else if  Calendar.current.isDateInToday(lastCompletionDate!) {
                isQuizComplete = true
            }
        }
        
        
        
        //    var body: some View {
        //        ScrollView{
        //            VStack {
        //                HStack{
        //                    // Text View
        //                    Text("Hi, \(name)!")
        //                        .bold()
        //                        .font(.system(size: 45))
        //                        .padding(.leading, 30)
        //
        //                    Spacer()
        //                    // Point
        //                    RoundedRectangle(cornerRadius: 5)
        //                        .fill(Color(UIColor(hex: "#6D9773")))
        //                        .frame(width: 90, height: 34)
        //                        .overlay(
        //                            Text("\(point)P").bold()
        //                                .foregroundColor(.white)
        //                                .font(.system(size: 20))
        //                                .multilineTextAlignment(.center)
        //                        )
        //                        .padding(.trailing, 30)
        //                }
        //                Image("tree")
        //                    .resizable()
        //                    .scaledToFit()
        //                    .frame(width: 280, height: 280)
        //                    .clipShape(Circle())
        //
        //                Text("You Save 1 Million Carbons Today !").bold()
        //                    .font(.system(size: 32))
        //                    .multilineTextAlignment(.center)
        //
        //
        //                // Step
        //                RoundedRectangle(cornerRadius: 15)
        //                    .fill(Color(UIColor(hex:"#B46617")))
        //                    .frame(width: 350, height: 100)
        //                    .shadow(color: .gray, radius: 5, x: 2, y: 2)
        //                    .overlay(
        //                        VStack(alignment: .leading){
        //                            HStack{
        //                                Image(systemName: steps.image)
        //                                    .font(.system(size: 25))
        //                                    .foregroundColor(.white)
        //
        //                                Text(steps.title).bold()
        //                                    .foregroundColor(.white)
        //                                    .font(.title)
        //                            }
        //                            HStack{
        //
        //                                Text("\(String(describing: progressStep)) / 10000 Steps")
        //                                    .font(.system(size: 20))
        //                                    .fontWeight(.light)
        //                                    .foregroundColor(.white)
        //                                    .layoutPriority(1)
        //                                    .lineLimit(1)
        //                                Image(systemName: "pencil")
        //                                    .font(.system(size: 15))
        //                                    .foregroundColor(.white)
        //                                    .opacity(0.7)
        //                                    .padding(.leading, -10)
        //
        //                            } .padding(.top, -10)
        //
        //                        } .padding(.leading,-120)
        //                    )
        //
        //                // Challenges
        //                RoundedRectangle(cornerRadius: 15)
        //                    .fill(Color(UIColor(hex:"#FFBA00")))
        //                    .frame(width: 350, height: 100)
        //                    .shadow(color: .gray, radius: 5, x: 2, y: 2)
        //                    .overlay(
        //                        VStack(alignment: .leading){
        //                            HStack{
        //                                Image(systemName: "rosette")
        //                                    .font(.system(size: 25))
        //                                    .foregroundColor(.white)
        //
        //                                Text("Challenges").bold()
        //                                    .foregroundColor(.white)
        //                                    .font(.title)
        //                            }
        //                            Text("0 / 5")
        //                                .font(.system(size: 20))
        //                                .fontWeight(.light)
        //                                .foregroundColor(.white)
        //                                .padding(.top, -10)
        //
        //                        } .padding(.leading,-120)
        //                    )
        //
        //                // Quiz
        //                RoundedRectangle(cornerRadius: 15)
        //                    .fill(Color(UIColor(hex:"#6D9773")))
        //                    .frame(width: 350, height: 120)
        //                    .shadow(color: .gray, radius: 5, x: 2, y: 2)
        //                    .overlay(
        //                        VStack(alignment: .leading){
        //                            HStack{
        //                                Image(systemName: "list.bullet.rectangle")
        //                                    .font(.system(size: 25))
        //                                    .foregroundColor(.white)
        //
        //                                Text("Quiz").bold()
        //                                    .foregroundColor(.white)
        //                                    .font(.title)
        //                            }
        //                            Text("Tap for daily quiz and get reward")
        //                                .font(.system(size:20))
        //                                .fontWeight(.light)
        //                                .foregroundColor(.white)
        //                                .padding(.top, -10)
        //
        //                        } .padding(.leading,-25)
        //                    )
        //            }
        //        }
        //        .onAppear {
        //            startTimer()
        //
        //        }
        //    }
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
