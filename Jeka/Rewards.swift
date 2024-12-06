//
//  Rewards.swift
//  Jeka
//
//  Created by student on 22/11/24.
//

import SwiftUI

struct Rewards: View {

    var body: some View {
        VStack{
            HStack{
                Text("Rewards")
                    .font(.system(size: 45))
                    .fontWeight(.bold)

                Spacer()

                Text("1000P")
                    .font(.system(size: 20))
                    .frame(width: 90, height: 30)
                    .background(Color(UIColor(hex:"#6D9773")))
                    .cornerRadius(5)
                    .foregroundStyle(Color.white)
            }

            .padding(.horizontal,22)

            HStack{
                Button("All"){
                    
                }
                .frame(width: 60, height: 20)
                .background(Color(UIColor(hex:"#6D9773")))
                .cornerRadius(5)
                .foregroundStyle(Color.white)
                .font(.footnote)

                Button("F&B"){

                }
                .frame(width: 60, height: 20)
                .background(Color(UIColor(hex:"#D9D9D9")))
                .cornerRadius(5)
                .foregroundStyle(Color.black)
                .font(.footnote)

                

                Button("Transportation"){

                }
                .frame(width: 116, height: 20)
                .background(Color(UIColor(hex:"#D9D9D9")))
                .cornerRadius(5)
                .foregroundStyle(Color.black)
                .font(.footnote)

                

            }.padding(.horizontal,22)
                .frame(maxWidth: .infinity, alignment: .leading)

            

            ScrollView {
                VStack {
                    ForEach(0..<7) {_ in
                        
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 15)
                            
                                .fill(Color.white)
                            
                                .frame(width: 376, height: 98)
                            
                                .padding(.bottom)
                            
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2)
                            
                                .cornerRadius(15)
                            
                            
                            
                            
                            
                            
                            
                            // Konten di dalam Rectangle
                            
                            HStack {
                                
                                // Lingkaran di kiri
                                
                                Circle()
                                
                                    .fill(Color.black)
                                
                                    .frame(width: 63, height: 63)
                                
                                    .padding()
                                
                                Divider()
                                
                                    .frame(width: 1)
                                
                                
                                
                                VStack{
                                    
                                    Text("Voucher wira wiri").font(.system(size: 18))
                                    
                                        .frame(alignment: .leading)
                                    
                                    Text("mendapatkan 10% diskon")
                                    
                                        .font(.system(size: 10))
                                    
                                        .foregroundStyle(Color.gray)
                                    
                                }.padding()
                                
                                Button(action: {}) {
                                    
                                    Text("50P")
                                    
                                        .font(.system(size: 14))
                                    
                                        .foregroundColor(.black)
                                    
                                        .frame(width: 70, height: 19)
                                    
                                        .background(Color(UIColor(hex: "FFBA00")))
                                    
                                        .cornerRadius(5)
                                    
                                }
                                
                            }.padding(.bottom)
                            
                            
                            
                        }
                        
                    }
                    
                }

            }
        }
        

    }

}



//#Preview {
//    Rewards()
//}
