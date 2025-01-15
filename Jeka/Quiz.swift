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
    @ObservedObject var pointsModel: PointsModel
    @State private var point = 0
    @State private var text = ""
    @Environment(\.modelContext) private var context
    var body: some View {
        //            if isQuizComplete {
        //                           // Display QuizComplete view when the quiz is finished
        //               // QuizComplete(countCorrect: $countCorrect)
        //            } else {
        if navigateToHome{
            HomeView(pointsModel: pointsModel)
                .navigationBarBackButtonHidden(true)
        } else {
            let question = ["Apa kebiasaan hemat energi yang baik untuk mengurangi jejak karbon di rumah?",
                                        "Apa yang bisa dilakukan dengan sampah organik untuk mengurangi emisi karbon?",
                                        "Apa kebiasaan mencuci yang dapat mengurangi emisi karbon?"]
                        
                        let answers: [[String]] = [
                            ["Membiarkan lampu menyala meski ruangan kosong", "Menggunakan lampu LED hemat energi", "Menggunakan peralatan rumah tangga tua yang boros energi", "Menyalakan lampu pada siang hari"],
                            ["Membiarkan sampah menumpuk di tempat sampah", "Mengubur sampah di halaman belakang", "Membuat kompos dari sampah organik", "Menimbun sampah di selokan"],
                            ["Mencuci dengan air dingin dan mengeringkan pakaian secara alami", "Menggunakan air panas dan pengering mesin setiap saat", "Mencuci pakaian sedikit demi sedikit dengan mesin cuci penuh", "Mencuci pakaian di pagi, siang, dan sore hari"]
                        ]

            let correctAnswer = ["Menggunakan lampu LED hemat energi", "Membuat kompos dari sampah organik", "Mencuci dengan air dingin dan mengeringkan pakaian secara alami"]
            
            let answerLetters = ["A", "B", "C", "D"]
            
            // Background Image
            ZStack{
                Image("Quiz")
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
                                            point += 50
                                        }
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
                                    if(countCorrect > 0){
                                        text = "You guessed \(countCorrect) correctly. You are rewarded \(point) points."
                                    } else
                                    {
                                        text = "You guessed 0 correctly. Try again tomorrow."
                                    }
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
                                .alert(text, isPresented: $isQuizComplete) {
                                    Button("OK") {
                                        navigateToHome = true
                                        let newPoint =  GetPoints(recievePoints: point)
                                        context.insert(newPoint)
                                        pointsModel.points += point
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
