//
//  Rewards.swift
//  Jeka
//
//  Created by student on 22/11/24.
//


import SwiftUI
import SwiftData

struct Rewards: View {
    @ObservedObject var pointsModel: PointsModel
    @State private var showingConfirmation = false
    @State private var showingInsufficientPointsAlert = false
    @State private var selectedVoucher: (name: String, description: String, points: Int, category: Category, isRedeemed: Bool, images : String)? = nil
    @State private var showingRedeemSuccess = false
    @Environment(\.modelContext) private var context

    enum Category: String {
        case all = "All"
        case fnb = "F&B"
        case transportation = "Transportation"
        case entertainment = "Entertainment"
    }

    @State private var selectedCategory: Category = .all
    @State private var vouchers = [
        (name: "Voucher Coffee", description: "Diskon 10% di kedai kopi batasnya hingga 26 Januari 2025, syarat dan ketentuan berlaku", points: 50, category: Category.fnb, isRedeemed: false, images: "voucher_minum"),
        (name: "Voucher Makanan", description: "Diskon 15% di restoran, batasnya hingga 20 Februari 2025", points: 15, category: Category.fnb, isRedeemed: false, images: "voucher_makan"),
        (name: "Voucher Taxi", description: "Diskon 25% untuk transportasi, batasnya hingga 8 Februari 2025", points: 25, category: Category.transportation, isRedeemed: false, images: "voucher_taxi"),
        (name: "Voucher Bus", description: "Diskon 30% untuk perjalanan bus, batasnya hingga 30 Januari 2025", points: 30, category: Category.transportation, isRedeemed: false, images: "voucher_bus"),
        (name: "Voucher Snacks", description: "Diskon 10% untuk makanan ringan, batasnya hingga 30 Januari 2025", points: 10, category: Category.fnb, isRedeemed: false, images: "voucher_snack"),
        (name: "Voucher Movie", description: "Diskon 15% untuk tiket film, batasnya hingga 21 Februari 2025", points: 15, category: Category.entertainment, isRedeemed: false, images: "voucher_movie"),
        (name: "Voucher Parking", description: "Diskon 20% untuk parkir, batasnya hingga 20 Januari 2025", points: 20, category: Category.transportation, isRedeemed: false, images: "voucher_parking")
    ]

    private let redeemedKey = "redeemedVouchers"

    private var filteredVouchers: [(name: String, description: String, points: Int, category: Category, isRedeemed: Bool, images: String)] {
        if selectedCategory == .all {
            return vouchers
        } else {
            return vouchers.filter { $0.category == selectedCategory }
        }
    }

    var body: some View {
        ZStack{
            VStack {
                headerView
                categoryButtons
                rewardList
                
            }
            .onAppear {
                loadRedeemedVouchers()
            }
            .alert(isPresented: $showingInsufficientPointsAlert) {
                Alert(title: Text("Insufficient Points"), message: Text("You do not have enough points to redeem this voucher."), dismissButton: .default(Text("OK")))
            }
            .alert("Are you sure?", isPresented: $showingConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Confirm") {
                    if let voucher = selectedVoucher {
                        redeemVoucher(voucher: voucher, context: context)
                    }
                }
            } message: {
                if let voucher = selectedVoucher {
                    Text("Are you sure you want to redeem '\(voucher.name)' for \(voucher.points) points?")
                }
            }
            if showingRedeemSuccess {
                        GeometryReader { geometry in
                            VStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 120))
                                    .foregroundColor(.green)
                                    .padding()
                                Text("Redeemed Successfully")
                                    .font(.title)
                                    .foregroundColor(.green)
                            }
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)  // Dynamically adjust width and height
                            .background(Color.white)  // Optional background color
                            .cornerRadius(12)  // Apply corner radius
                            .shadow(radius: 10)  // Optional shadow for visibility
                            .padding(40)  // Optional padding from edges
                            .transition(.opacity)  // Use opacity transition
                            .animation(.easeInOut, value: showingRedeemSuccess)
                            .zIndex(1)  // Ensure it appears on top
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)  // Center the message
                        }
                    }
        }.padding(.horizontal)

        
        
        
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
                .background(Color(UIColor(hex: "#6D9773")))
                .cornerRadius(5)
                .foregroundColor(.white)
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
            .foregroundColor(selectedCategory == .all ? .white : .black)
            .font(.footnote)

            Button("F&B") {
                withAnimation {
                    selectedCategory = .fnb
                }
            }
            .frame(width: 60, height: 20)
            .background(selectedCategory == .fnb ? Color(UIColor(hex: "#6D9773")) : Color(UIColor(hex: "#D9D9D9")))
            .cornerRadius(5)
            .foregroundColor(selectedCategory == .fnb ? .white : .black)
            .font(.footnote)

            Button("Transportation") {
                withAnimation {
                    selectedCategory = .transportation
                }
            }
            .frame(width: 116, height: 20)
            .background(selectedCategory == .transportation ? Color(UIColor(hex: "#6D9773")) : Color(UIColor(hex: "#D9D9D9")))
            .cornerRadius(5)
            .foregroundColor(selectedCategory == .transportation ? .white : .black)
            .font(.footnote)
            
            Button("Entertainment"){
                withAnimation {
                    selectedCategory = .entertainment
                }
            }
            .frame(width: 116, height: 20)
            .background(selectedCategory == .entertainment ? Color(UIColor(hex: "#6D9773")) : Color(UIColor(hex: "#D9D9D9")))
            .cornerRadius(5)
            .foregroundColor(selectedCategory == .entertainment ? .white : .black)
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
    
    private func rewardItemView(voucher: (name: String, description: String, points: Int, category: Category, isRedeemed: Bool, images: String)) -> some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width < geometry.size.height
            Button(action: {
                if pointsModel.points >= voucher.points {
                    if isVoucherRedeemed(voucher: voucher) {
                        // Show an alert or feedback saying the voucher has already been redeemed
                        showingInsufficientPointsAlert.toggle()
                    } else {
                        selectedVoucher = voucher
                        showingConfirmation.toggle()
                    }
                } else {
                    showingInsufficientPointsAlert.toggle()
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(voucher.isRedeemed ? Color.gray.opacity(0.5) : Color.white)
                        .frame(width: geometry.size.width, height: isLandscape ? 120 : 98)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2)

                    HStack {
                        Image("\(voucher.images)")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 63, height: 63)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2)
                            )

                        Divider()
                            .frame(width: 1, height: 98)

                        VStack(alignment: .leading) {
                            Text(voucher.name)
                                .font(.system(size: 18))
                                .foregroundColor(voucher.isRedeemed ? .gray : .black)

                            Text(voucher.description)
                                .font(.system(size: 10))
                                .foregroundColor(voucher.isRedeemed ? .gray : .gray)
                        }
                        
                        .frame(width: geometry.size.width * 0.43, alignment: .leading)
                        
                        Spacer()

                        Text("\(voucher.points)P")
                            .font(.system(size: 14))
                            .foregroundColor(voucher.isRedeemed ? .gray : .black)
                            .frame(width: 70, height: 19)
                            .background(voucher.isRedeemed ? Color.gray.opacity(0.5) : Color(UIColor(hex: "FFBA00")))
                            .cornerRadius(5)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .frame(height:112) // Adjust height for GeometryReader
    }


    private func isVoucherRedeemed(voucher: (name: String, description: String, points: Int, category: Category, isRedeemed: Bool, images: String)) -> Bool {
        let redeemedNames = UserDefaults.standard.stringArray(forKey: redeemedKey) ?? []
        return redeemedNames.contains(voucher.name)
    }

    func redeemVoucher(voucher: (name: String, description: String, points: Int, category: Category, isRedeemed: Bool, images: String), context: ModelContext) {
        if isVoucherRedeemed(voucher: voucher) {
            showingInsufficientPointsAlert.toggle()
            return
        }

        pointsModel.points -= voucher.points
        saveVoucher(name: voucher.name, redeemedPoints: voucher.points, category: voucher.category.rawValue, context: context, images: voucher.images)
        saveRedeemedVoucher(name: voucher.name)  // Save the voucher as redeemed
        let updatedVouchers = fetchRedeemedVouchers(context: context)
            print("Redeemed Vouchers:", updatedVouchers)
        // Remove the redeemed voucher from the list
        if let index = vouchers.firstIndex(where: { $0.name == voucher.name }) {
            vouchers.remove(at: index)  // Remove the voucher after redemption
        }

        selectedVoucher = nil
        showingRedeemSuccess = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showingRedeemSuccess = false
        }
    }


    
    private func loadRedeemedVouchers() {
        let redeemedNames = UserDefaults.standard.stringArray(forKey: redeemedKey) ?? []
        vouchers.removeAll { redeemedNames.contains($0.name) }
    }

    private func saveRedeemedVoucher(name: String) {
        var redeemedNames = UserDefaults.standard.stringArray(forKey: redeemedKey) ?? []
        
        if !redeemedNames.contains(name) {
            redeemedNames.append(name)
            UserDefaults.standard.set(redeemedNames, forKey: redeemedKey)
        }
    }
    
    func saveVoucher(name: String, redeemedPoints: Int, category: String, context: ModelContext, images: String) {
        let newVoucher = RedeemedVoucher(name: name, redeemedPoints: redeemedPoints, category: category, imageName: images)
        context.insert(newVoucher)
        do {
            try context.save()
            print("Voucher \(name) berhasil disimpan.")
        } catch {
            print("Gagal menyimpan voucher: \(error.localizedDescription)")
        }
    }
    func fetchRedeemedVouchers(context: ModelContext) -> [RedeemedVoucher] {
        do {
            let redeemedVouchers = try context.fetch(FetchDescriptor<RedeemedVoucher>())
            return redeemedVouchers
        } catch {
            print("Gagal mengambil data voucher: \(error)")
            return []
        }
    }
}

