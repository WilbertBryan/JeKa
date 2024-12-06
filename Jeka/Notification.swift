//
//  Notification.swift
//  Jeka
//
//  Created by student on 22/11/24.
//

import SwiftUI
import SwiftData


struct Notification: View {

    @Query var redeemedVouchers: [RedeemedVoucher]

    var body: some View {
        VStack{
            HStack{
                Text("Notification")
                    .font(.system(size: 45))
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal,22)
            ScrollView {
                VStack(spacing: 10) {
                    // Mengurutkan voucher berdasarkan dateRedeemed sebelum menampilkan
                    ForEach(redeemedVouchers.sorted(by: { $0.dateRedeemed > $1.dateRedeemed }), id: \.id) { voucher in
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2)
                                .frame(maxWidth: .infinity, minHeight: 100)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(voucher.name)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text("Points: \(voucher.points)")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                Text("Category: \(voucher.category)")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                Text("Redeemed on: \(voucher.dateRedeemed.formatted(.dateTime))")
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







// Hex Color Extension

#Preview {
    Notification()

}
