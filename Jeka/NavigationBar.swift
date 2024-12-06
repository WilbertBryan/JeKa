//
//  NavigationBar.swift
//  Jeka
//
//  Created by student on 19/11/24.
//

import SwiftUI
struct TabBarBackgroundModifier: ViewModifier {
    var backgroundColor: UIColor
    var unselectedColor: UIColor

    init(backgroundColor: UIColor, unselectedColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.unselectedColor = unselectedColor
        // Apply appearance changes for the tab bar
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = backgroundColor

        // Modify selected/unselected icon colors
        appearance.stackedLayoutAppearance.normal.iconColor = unselectedColor
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(hex: "#FFBA00") // Active tab color (Accent color)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    func body(content: Content) -> some View {
        content
    }
}

// Custom view extension to apply the modifier more easily
extension View {
    func tabBarBackgroundColor(_ backgroundColor: UIColor, unselectedIconColor: UIColor) -> some View {
        self.modifier(TabBarBackgroundModifier(backgroundColor: backgroundColor, unselectedColor: unselectedIconColor))
    }
}

struct NavigationBar: View {
    @EnvironmentObject var manager: HealthManager
    var body: some View {
        TabView {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .environmentObject(HealthManager())
                    Rewards()
                        .tabItem {
                            Image(systemName: "cart.fill")
                            Text("Rewards")
                        }
                    Text("Nearby Screen")
                        .tabItem {
                            Image(systemName: "qrcode")
                            Text("QR")
                        }
                    Notification()
                        .tabItem {
                            Image(systemName: "bell.fill")
                            Text("Notification")
                        }
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                }
                .accentColor(Color(UIColor(hex: "#FFBA00")))
                .tabBarBackgroundColor(UIColor(hex: "#0C3B2E"), unselectedIconColor: UIColor.white)
    }
}

#Preview {
    NavigationBar()
}
