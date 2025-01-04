//
//  Vouchers.swift
//  Jeka
//
//  Created by MacBook Pro on 04/01/25.
//

import SwiftUI
import SwiftData

struct Vouchers: View {
    @Query var redeemedVouchers: [RedeemedVoucher]

    var body: some View {
        VStack {
            HStack {
                Text("Vouchers")
                    .font(.system(size: 45))
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal, 22)
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(redeemedVouchers, id: \.id) { voucher in
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2)
                                .frame(maxWidth: .infinity, minHeight: 150)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                // Voucher Image
                                Image(voucher.imageName)  // Adjusted to directly use voucher.imageName
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, minHeight: 100)
                                    .clipped()
                                
                                // Voucher Name
                                Text(voucher.name)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    
                                
                                // Voucher Date (formatted)
                                Text("Redeemed on: \(voucher.dateRedeemed, style: .date)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

#Preview {
    Vouchers()
}
