//
//  ContentView.swift
//  LearningApp
//
//  Created by Johnathan Lee on 4/21/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        ScrollView {
            
            LazyVStack {
                
                if model.currentModule != nil {
                    ForEach(0..<model.currentModule!.content.lessons.count) {
                        lessonIndex in
                        
                        NavigationLink(
                            destination: ContentDetailView()
                                .onAppear(perform: {
                                    model.beginLesson(lessonIndex)
                                }),
                            label: {
                                ContentViewRow(lessonIndex: lessonIndex)
                            })
                        
                    }
                }
                
            }
            .padding()
            .navigationTitle("Learn \(model.currentModule?.category ?? "")")
            .accentColor(.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
