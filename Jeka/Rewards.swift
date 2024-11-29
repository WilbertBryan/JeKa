//
//  Rewards.swift
//  Jeka
//
//  Created by student on 22/11/24.
//

import SwiftUI

struct Rewards: View {
    @ObservedObject var pointsModel: PointsModel
    @State private var showingConfirmation = false
    @State private var showingInsufficientPointsAlert = false
    @State private var selectedVoucher: (name: String, description: String, points: Int, category: Category)? = nil
    @State private var showingRedeemSuccess = false
    enum Category: String {
           case all = "All"
           case fnb = "F&B"
           case transportation = "Transportation"
       }

    @State private var selectedCategory: Category = .all
        @State private var vouchers = [
            (name: "Voucher Coffee", description: "Diskon 10% di kedai kopi batasnya hingga 2 Desember 2024, segera ambil syarat dan ketentuan berlaku", points: 50, category: Category.fnb),
            (name: "Voucher Makanan", description: "Diskon 15% di restoran", points: 15, category: Category.fnb),
            (name: "Voucher Taxi", description: "Diskon 25% untuk transportasi", points: 25, category: Category.transportation),
            (name: "Voucher Bus", description: "Diskon 30% untuk perjalanan bus", points: 30, category: Category.transportation),
            (name: "Voucher Snacks", description: "Diskon 10% untuk makanan ringan", points: 10, category: Category.fnb),
            (name: "Voucher Movie", description: "Diskon 15% untuk tiket film", points: 15, category: Category.all),
            (name: "Voucher Parking", description: "Diskon 20% untuk parkir", points: 20, category: Category.transportation)
        ]
    private var filteredVouchers: [(name: String, description: String, points: Int, category: Category)] {
            if selectedCategory == .all {
                return vouchers
            } else {
                return vouchers.filter { $0.category == selectedCategory }
            }
        }
    var body: some View {
        VStack {
                    headerView
                    categoryButtons
                    rewardList
            if showingRedeemSuccess {
                VStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 120))
                        .foregroundColor(.green)
                        .padding()
                    Text("Redeemed Successfully")
                        .font(.title)
                        .foregroundColor(.green)
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
                }
        .alert(isPresented: $showingInsufficientPointsAlert) {
                    Alert(title: Text("Insufficient Points"), message: Text("You do not have enough points to redeem this voucher."), dismissButton: .default(Text("OK")))
                }
       
        .alert("Are you sure?", isPresented: $showingConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm") {
                   if let voucher = selectedVoucher {
                               redeemVoucher(points: voucher.points)
                           }
               }
           } message: {
               if let voucher = selectedVoucher {
                       Text("Are you sure you want to redeem '\(voucher.name)' for \(voucher.points) points?")
                   }
           }
        
        }
            
    
    
    private var headerView: some View {
            HStack {
                Text("Rewards")
                    .font(.system(size: 45))
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("\(pointsModel.points)P")
                    .font(.system(size: 20))
                    .frame(width: 90, height: 30)
                    .background(Color(UIColor(hex:"#6D9773")))
                    .cornerRadius(5)
                    .foregroundStyle(Color.white)
            }
            .padding(.horizontal, 22)
        }
    
    private var categoryButtons: some View {
            HStack {
                Button("All") {
                    withAnimation {
                                    selectedCategory = .all
                                }

                }
                .frame(width: 60, height: 20)
                .background(selectedCategory == .all ? Color(UIColor(hex: "#6D9773")) : Color(UIColor(hex: "#D9D9D9")))
                .cornerRadius(5)
                .foregroundStyle(selectedCategory == .all ? Color.white : Color.black)
                .font(.footnote)
                
                Button("F&B") {
                    withAnimation {
                        selectedCategory = .fnb
                                }
                }
                .frame(width: 60, height: 20)
                .background(selectedCategory == .fnb ? Color(UIColor(hex: "#6D9773")) : Color(UIColor(hex: "#D9D9D9")))
                .cornerRadius(5)
                .foregroundStyle(selectedCategory == .fnb ? Color.white : Color.black)
                .font(.footnote)
    
                Button("Transportation") {
                    withAnimation {
                        selectedCategory = .transportation
                                }
                }
                .frame(width: 116, height: 20)
                .background(selectedCategory == .transportation ? Color(UIColor(hex: "#6D9773")) : Color(UIColor(hex: "#D9D9D9")))
                .cornerRadius(5)
                .foregroundStyle(selectedCategory == .transportation ? Color.white : Color.black)
                .font(.footnote)
            }
            .padding(.horizontal, 22)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    private var rewardList: some View {
            ScrollView {
                VStack {
                    ForEach(filteredVouchers.indices, id: \.self) { index in
                        rewardItemView(voucher: filteredVouchers[index])
                    }
                }.padding()
            }
        }
    
    private func rewardItemView(voucher: (name: String, description: String, points: Int, category: Category)) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .frame(width: 376, height: 98)
                    .padding(.bottom)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2)
                    .cornerRadius(15)
                
                HStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 63, height: 63)
                        .padding()
                    
                    Divider()
                        .frame(width: 1)
                    
                    VStack {
                        Text(voucher.name)
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                            .frame(width: 157, alignment: .leading)

                        Text(voucher.description)
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                            .frame(width: 157, alignment: .leading)
                    }
                    
                    
                    Spacer()
                    
                    Button("\(voucher.points)P") {
                        if pointsModel.points >= voucher.points {
                                selectedVoucher = voucher
                            showingConfirmation.toggle() // Tampilkan dialog konfirmasi
                            } else {
                                showingInsufficientPointsAlert.toggle() // Tampilkan alert saldo tidak cukup
                            }
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .frame(width: 70, height: 19)
                    .background(Color(UIColor(hex: "FFBA00")))
                    .cornerRadius(5)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    
    func redeemVoucher(points: Int) {
            pointsModel.points -= points
            selectedVoucher = nil // Reset voucher setelah redeem
        showingRedeemSuccess = true
                   
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showingRedeemSuccess = false
        }
        }
    }

