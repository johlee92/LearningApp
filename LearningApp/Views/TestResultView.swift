//
//  TestResultView.swift
//  LearningApp
//
//  Created by Johnathan Lee on 4/25/22.
//

import SwiftUI

struct TestResultView: View {
    
    @EnvironmentObject var model: ContentModel
    var numCorrect:Int
    
    var body: some View {
        VStack {
            Text(resultHeading)
                .font(.title)
            
            Spacer()
            
            Text("\(numCorrect) out of \(model.currentModule?.test.questions.count ?? 0) questions correct")
            
            Spacer()
            
            Button {
                model.currentTestSelected = nil
            } label: {
                ZStack {
                    RectangleCard(color: .green)
                        .frame(height: 48)
                    
                    Text("Complete")
                        .bold()
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    var resultHeading: String {
        
        guard model.currentModule != nil else {
            return ""
        }
        
        // Assumes there's a currentModule set given it's progressing in test view
        let pct = Double(numCorrect)/Double(model.currentModule!.test.questions.count)
        
        if pct > 0.5 {
            return "Great!"
        } else if pct > 0.25 {
            return "Keep going!"
        } else {
            return "Review!"
        }
    }
}

struct TestResultView_Previews: PreviewProvider {
    static var previews: some View {
        TestResultView(numCorrect: 2)
            .environmentObject(ContentModel())
    }
}
