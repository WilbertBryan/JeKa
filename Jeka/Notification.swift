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
    @Query var getPoints: [GetPoints]
    
    var combinedData: [PointRecord] {
        // Map RedeemedVoucher data to PointRecord
        let redeemedData = redeemedVouchers.map {
            PointRecord(
                type: .spent,
                description: "You redeemed \($0.name) for \($0.redeemedPoints) Points",
                date: $0.dateRedeemed,
                category: $0.category
            )
        }
        
        // Map GetPoints data to PointRecord
        let earnedData = getPoints.map {
            PointRecord(
                type: .earned,
                description: "You received \($0.recievePoints) Points",
                date: $0.dateReceived,
                category: nil // Earned points don't have a category
            )
        }
        
        // Combine and sort by date (newest first)
        return (redeemedData + earnedData).sorted { $0.date > $1.date }
    }
    

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
                    ForEach(combinedData, id: \.id) { record in
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2)
                                .frame(maxWidth: .infinity, minHeight: 100)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(record.description)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                     // Green for earned, red for spent
                                if let category = record.category {
                                    Text("Category: \(category)")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                Text("Date: \(record.date.formatted(.dateTime))")
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

struct PointRecord: Identifiable {
    enum RecordType {
        case earned, spent
    }
    
    let id = UUID()                   // Unique ID for each record
    let type: RecordType              // Whether the record is earned or spent
    let description: String           // Display text for the record
    let date: Date                    // Date of the record
    let category: String?             // Optional: category for spent points
}





// Hex Color Extension

#Preview {
    Notification()

}
