//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by Johnathan Lee on 4/20/22.
//

import SwiftUI
import Firebase

@main
struct LearningApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
