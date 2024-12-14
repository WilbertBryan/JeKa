//
//  JekaApp.swift
//  Jeka
//
//  Created by student on 19/11/24.
//

import SwiftUI
import SwiftData

extension UIColor {
    public convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}



@Model
class RedeemedVoucher {
    @Attribute(.unique) var id: UUID // ID unik untuk setiap voucher
    var name: String                 // Nama voucher
    var redeemedPoints: Int                  // Poin yang digunakan
    var category: String             // Kategori voucher
    var dateRedeemed: Date           // Waktu voucher diredeem

    // Initializer untuk membuat instance baru
    init(id: UUID = UUID(), name: String, redeemedPoints: Int, category: String, dateRedeemed: Date = Date()) {
        self.id = id
        self.name = name
        self.redeemedPoints = redeemedPoints
        self.category = category
        self.dateRedeemed = dateRedeemed
    }
}
class GetVoucher{
    @Attribute(.unique) var getId : UUID
    var recievePoints: Int
    var dateReceived: Date
    
    init(getId:UUID = UUID(), recievePoints: Int, dateReceived: Date = Date()){
        self.getId = getId
        self.recievePoints = recievePoints
        self.dateReceived = dateReceived
    }
}


@main
struct JekaApp: App {
    var body: some Scene {
        WindowGroup {
            LoadingScreen()
                .modelContainer(for: [RedeemedVoucher.self])
        }
    }
}
