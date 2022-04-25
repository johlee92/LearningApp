//
//  TestView.swift
//  LearningApp
//
//  Created by Johnathan Lee on 4/23/22.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var selectedAnswerIndex = -1
    @State var numCorrect = 0
    @State var submitted = false
    
    var body: some View {
        if model.currentQuestion != nil {
            VStack (alignment: .leading) {
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                
                // Question
                CodeTextView()
                    .padding(.horizontal, 20)
                
                // Answers
                ScrollView {
                    VStack {
                        ForEach (0..<model.currentQuestion!.answers.count, id: \.self) {
                            index in
                            
                            
                            Button {
                                // Track selected index
                                selectedAnswerIndex = index
                            } label: {
                                ZStack {
                                    
                                    if submitted == false {
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height: 48)
                                    } else {
                                        if index == selectedAnswerIndex && index == model.currentQuestion!.correctIndex {
                                            
                                            RectangleCard(color:Color.green)
                                                .frame(height: 48)
                                        } else if index == selectedAnswerIndex && index != model.currentQuestion!.correctIndex {
                                            
                                            RectangleCard(color:Color.red)
                                                .frame(height: 48)
                                        } else if index == model.currentQuestion!.correctIndex {
                                            
                                            RectangleCard(color:Color.green)
                                                .frame(height: 48)
                                        } else  {
                                            
                                            RectangleCard(color:.white)
                                                .frame(height: 48)
                                        }
                                    }
                                    
                                    Text(model.currentQuestion!.answers[index])
                                }
                                .accentColor(.black)
                                .padding()
                            }
                            .disabled(submitted)
                        }
                    }
                }
                
                // Button
                Button {
                    
                    submitted = true
                    
                    if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                        numCorrect += 1
                    }
                    
                } label: {
                    ZStack {
                        RectangleCard(color: Color.green)
                            .frame(height: 48)
                        
                        Text("Submit and Finish")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .accentColor(.black)
                    .padding()
                }
                .disabled(selectedAnswerIndex == -1)

                
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
