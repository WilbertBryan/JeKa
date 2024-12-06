//
//  LoadingScreen.swift
//  Jeka
//
//  Created by student on 22/11/24.
//

import SwiftUI



struct LoadingScreen: View {
    @State private var isActive = false
    @EnvironmentObject var healthManager: HealthManager
    var body: some View {
        if isActive{
            NavigationBar()
                .environmentObject(HealthManager())
        }
        else{
            VStack {
                HStack {
                    Image("Logo") // Menggunakan gambar logo dari Assets
                        .resizable() // Membuat gambar dapat diubah ukurannya
                        .frame(width: 50, height: 50) // Menentukan ukuran gambar
                        .foregroundColor(.blue) // (Opsional) Jika gambar mendukung template warna
                    
                    Text("JEKA")
                        .font(.title) // Ukuran font besar
                        .fontWeight(.bold) // Teks dalam bold
                }
                .padding()
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 ) {
                    withAnimation{
                        isActive = true
                    }
                }
            }

        }
    }
    
//    var body: some View {
//        VStack {
//            HStack {
//                Image("Logo") // Menggunakan gambar logo dari Assets
//                    .resizable() // Membuat gambar dapat diubah ukurannya
//                    .frame(width: 50, height: 50) // Menentukan ukuran gambar
//                    .foregroundColor(.blue) // (Opsional) Jika gambar mendukung template warna
//
//                Text("JEKA")
//                    .font(.title) // Ukuran font besar
//                    .fontWeight(.bold) // Teks dalam bold
//            }
//            .padding()
//        }
//    }
}



//#Preview {
//    LoadingScreen()
//
//}
