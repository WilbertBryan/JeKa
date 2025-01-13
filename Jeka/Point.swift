//
//  Untitled.swift
//  Jeka
//
//  Created by MacBook Pro on 23/11/24.
//

import SwiftUI

class PointsModel: ObservableObject {
    @Published var points: Int {
           didSet {
               // Simpan nilai ke UserDefaults setiap kali `points` berubah
               UserDefaults.standard.set(points, forKey: "pointsKey")
           }
       }
       
    init() {
        // Ambil nilai dari UserDefaults atau gunakan nilai default 500
        self.points = UserDefaults.standard.object(forKey: "pointsKey") as? Int ?? 0
    }
}
