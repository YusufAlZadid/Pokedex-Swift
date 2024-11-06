//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Al Zadid Yusuf on 11/6/24.
//

import SwiftUI

@main
struct PokedexApp: App {
    init() {
        Self.configureNavigationBarAppearance()
        Self.configureTabBarAppearance()
        Self.configureGlobalAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Alola-inspired gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.08, blue: 0.2),  // Deep Alolan night
                        Color(red: 0.1, green: 0.15, blue: 0.3),   // Tropical twilight
                        Color(red: 0.15, green: 0.2, blue: 0.35)   // Ocean depths
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Subtle pattern overlay
                GeometryReader { geometry in
                    Path { path in
                        for i in stride(from: 0, to: geometry.size.width, by: 20) {
                            for j in stride(from: 0, to: geometry.size.height, by: 20) {
                                path.addEllipse(in: CGRect(x: i, y: j, width: 2, height: 2))
                            }
                        }
                    }
                    .fill(Color.white.opacity(0.05))
                }
                .ignoresSafeArea()
                
                ContentView()
                    .preferredColorScheme(.dark)
                    .tint(RotomColors.primary)
            }
        }
    }
    
    private static func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        // Rotom-dex styling
        appearance.backgroundColor = UIColor(RotomColors.background)
        appearance.backgroundEffect = UIBlurEffect(style: .dark)
        
        // Title styling with Rotom-dex glow effect
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(RotomColors.primary),
            .font: UIFont.systemFont(ofSize: 20, weight: .heavy),
            .shadow: NSShadow(color: UIColor(RotomColors.glow), offset: .zero, blur: 8)
        ]
        
        let largeTitleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(RotomColors.primary),
            .font: UIFont.systemFont(ofSize: 34, weight: .heavy),
            .shadow: NSShadow(color: UIColor(RotomColors.glow), offset: .zero, blur: 12)
        ]
        
        appearance.titleTextAttributes = titleAttributes
        appearance.largeTitleTextAttributes = largeTitleAttributes
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor(RotomColors.primary)
    }
    
    private static func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(RotomColors.background).withAlphaComponent(0.95)
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor(RotomColors.primary).withAlphaComponent(0.6)
        itemAppearance.selected.iconColor = UIColor(RotomColors.primary)
        
        appearance.stackedLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    private static func configureGlobalAppearance() {
        UITextField.appearance().tintColor = UIColor(RotomColors.primary)
        UITextField.appearance().textColor = .white
        UIScrollView.appearance().indicatorStyle = .white
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
}



extension NSShadow {
    convenience init(color: UIColor, offset: CGSize, blur: CGFloat) {
        self.init()
        self.shadowColor = color
        self.shadowOffset = offset
        self.shadowBlurRadius = blur
    }
}
