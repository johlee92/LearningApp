//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by Johnathan Lee on 4/20/22.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
