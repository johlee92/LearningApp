//
//  ContentViewRow.swift
//  LearningApp
//
//  Created by Johnathan Lee on 4/22/22.
//

import SwiftUI

struct ContentViewRow: View {
    
    @EnvironmentObject var model: ContentModel
    
    var lessonIndex:Int
    
    var lesson: Lesson {
        if model.currentModule != nil && lessonIndex < model.currentModule!.content.lessons.count {
            return model.currentModule!.content.lessons[lessonIndex]
        } else {
            return Lesson(id: 0, title: "", video: "", duration: "", explanation: "")
        }
    }
    
    var body: some View {
        
//        let lesson = model.currentModule!.content.lessons[lessonIndex]
        
        ZStack (alignment: .leading) {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(height: 66)
            
            HStack (spacing: 20){
                Text(String(lessonIndex + 1))
                
                VStack (alignment: .leading, spacing: 5) {
                    Text(lesson.title)
                        .bold()
                    Text(lesson.duration)
                }
            }
            .padding()
        }
    }
}

struct ContentViewRow_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewRow(lessonIndex: 0)
    }
}
