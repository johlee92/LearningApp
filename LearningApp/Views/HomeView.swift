//
//  ContentView.swift
//  LearningApp
//
//  Created by Johnathan Lee on 4/20/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        NavigationView {
            VStack (alignment: .leading) {
                Text("What do you want to do today?")
                    .padding(.leading, 20)
                
                ScrollView {
                    LazyVStack (spacing: 20) {
                        ForEach(model.modules) {
                            module in
                            
                            NavigationLink(
                                destination: ContentView()
                                    .onAppear(perform: {
                                        model.beginModule(module.id)
                                        print(model.currentContentSelected)
                                    }),
                                tag: module.id,
                                selection: $model.currentContentSelected,
                                label: {
                            
                                    // Learning card
                                    HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) lessons", time: module.content.time)
                                    
                                })
                            
                                    // Test card
                                    HomeViewRow(image: module.test.image, title: "\(module.category) test", description: module.test.description, count: "\(module.test.questions.count) questions", time: module.test.time)
                                
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
            }
            .navigationTitle("Get Started")
        }
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
