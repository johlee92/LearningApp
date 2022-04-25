//
//  TestView.swift
//  LearningApp
//
//  Created by Johnathan Lee on 4/23/22.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        if model.currentQuestion != nil {
            VStack {
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                
                CodeTextView()
                
            }
            .navigationTitle("\(model.currentModule?.category ?? "") Test")
        }
        // For some reason, need an else statement...
        // Appears to be an Xcode 14.5+ bug
        else {
            // ProgressView is an UIView that shows loading
            ProgressView()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
