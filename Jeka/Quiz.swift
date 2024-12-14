//
//  Quiz.swift
//  Jeka
//
//  Created by student on 22/11/24.
//

import SwiftUI
struct AnswerButton: View {
    let letter: String
    let answer: String
    var isSelected: Bool // Whether this button is selected
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? Color(UIColor(hex: "#6D9773")) : Color(UIColor(hex: "#FFFFFF"))) // Change color if selected
                .shadow(color: Color(UIColor(hex: "#6D9773")), radius: 6, x: 2, y: 4)
                .frame(width: 300, height: 55)
                .overlay(
                    HStack {
                        Text(letter + ".")
                            .bold()
                            .foregroundColor(isSelected ? Color(UIColor(hex: "#FFFFFF")) : Color(UIColor(hex: "#6D9773")))
                            .font(.system(size: 20))
                        Text(answer)
                            .foregroundColor(isSelected ? Color(UIColor(hex: "#FFFFFF")) : Color(UIColor(hex: "#6D9773")))
                            .font(.system(size: 20))
                            .multilineTextAlignment(.leading)
                    }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                )
        }
        .padding(.bottom)
    }
}
struct Quiz: View {
    @State private var count = 0
    @State private var selectedAnswerIndex: Int? = nil // Track the selected answer
    @State private var isAnswerSelected: Bool? = false
    @State private var countCorrect = 0
    @State private var navigateToHome = false
    @Binding var isQuizComplete: Bool
    @StateObject private var pointsModel = PointsModel()
    var body: some View {
        //            if isQuizComplete {
        //                           // Display QuizComplete view when the quiz is finished
        //               // QuizComplete(countCorrect: $countCorrect)
        //            } else {
        if navigateToHome{
            HomeView(pointsModel: pointsModel)
                .navigationBarBackButtonHidden(true)
        } else {
            
            let question = ["What is the capital of France?",
                            "Who wrote the play 'Romeo and Juliet'?",
                            "Which planet is known as the Red dssadadanshdbhasbdhjsbdhjasbdhjabhdjbshjkdbdahsjbdjasbdjksabdjkbsa Planet?"]
            
            let answers: [[String]] = [
                ["Paris", "London", "Berlin", "Madrid"],
                ["William Shakespeare", "Charles Dickens", "Mark Twain", "Oscar Wilde"],
                ["Mars", "Venus", "Jupiter", "Saturn"]
            ]
            
            let correctAnswer = ["London", "Mark Twain", "Mars"]
            
            let answerLetters = ["A", "B", "C", "D"]
            
            // Background Image
            ZStack{
                Image("quiz")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(UIColor(hex: "#FFFFFF")))
                    .frame(width: 350, height: 600)
                    .overlay(
                        
                        VStack{
                            Text("Question \(count+1) of \(question.count)")
                                .bold()
                                .foregroundColor(Color(UIColor(hex: "#6D9773")))
                                .font(.system(size: 20))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                                .padding(.bottom)
                            
                            Text(question[count]).bold()
                                .font(.title)
                                .foregroundColor(.black)
                                .font(.system(size: 20))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                            
                            // Answer Options
                            ForEach(0..<answers[count].count, id: \.self) { index in
                                AnswerButton(
                                    letter: answerLetters[index],
                                    answer: answers[count][index],
                                    isSelected: selectedAnswerIndex == index, // Check if this is the selected answer
                                    action: {
                                        selectedAnswerIndex = index // Set the selected answer index
                                        isAnswerSelected = true
                                        let userSelect = answers[count][index]
                                        
                                        // CHECK CORRECT ANSWER
                                        if correctAnswer[count] == userSelect {
                                            countCorrect += 1
                                        }
                                        
                                        //                                    if count < question.count - 1 {
                                        //                                        count = 1
                                        //                                    } else {
                                        //                                        print("Quiz complete!")
                                        //                                        count = 0
                                        //                                    }
                                    }
                                )
                            }
                            
                            // Next
                            Button(action: {
                                if count < question.count - 1 {
                                    count += 1 // Move to the next question
                                    selectedAnswerIndex = nil // Reset selected answer
                                    isAnswerSelected = false
                                } else{
                                    isQuizComplete = true
                                    UserDefaults.standard.set(Date(), forKey: "LastQuizCompletionDate")
                                    
                                }
                            }) {
                                Text("Next")
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 50)
                                    .background(isAnswerSelected ?? false ? Color(UIColor(hex: "#6D9773")) : Color(UIColor(hex: "#FFFFFF")))
                                    .cornerRadius(10)
                                
                            } .disabled(selectedAnswerIndex == nil) // Disable "Next" until an answer is selected
                                .alert("Your correct answer is \(countCorrect)", isPresented: $isQuizComplete) {
                                    Button("OK") {
                                        navigateToHome = true
                                    }
                                }
                        }
                        
                    )
            }
        }
        
    }
}



//#Preview {
//    Quiz()
//}

//struct Quiz_Previews: PreviewProvider {
//    @State static private var isQuizComplete = false // State for preview
//
//    static var previews: some View {
//        Quiz(isQuizComplete: $isQuizComplete)  // Pass binding to preview
//    }
//}
