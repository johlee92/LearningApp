//
//  ContentModel.swift
//  LearningApp
//
//  Created by Johnathan Lee on 4/20/22.
//

import Foundation

class ContentModel: ObservableObject {
    
    @Published var modules = [Module]()
    
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    @Published var lessonDescription = NSAttributedString()
    
    var styleData: Data?
    
    init() {
        getLocalData()
    }
    
    // MARK: Data Methods
    
    func getLocalData() {
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            
            let data = try Data(contentsOf: jsonUrl!)
            let decoder = JSONDecoder()
            
            do {
                
                let moduleData = try decoder.decode([Module].self, from: data)
                
                self.modules = moduleData
                
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            let styleData = try Data(contentsOf: styleUrl!)
            self.styleData = styleData
        } catch {
            print(error)
        }
    }
    
    // MARK: Module navigation methods
    
    func beginModule(_ moduleId:Int) {
        
        for index in 0..<modules.count {
            if modules[index].id == moduleId {
                currentModuleIndex = index
                break
            }
        }
        
        currentModule = modules[currentModuleIndex]
    }
    
    func beginLesson(_ lessonIndex:Int) {
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        } else {
            currentLessonIndex = 0
        }
        
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        lessonDescription = addStyling(currentLesson!.explanation)
    }
    
    func hasNextLesson() -> Bool {
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
    }
    
    func nextLesson() {
        currentLessonIndex += 1
        
        if currentLessonIndex < currentModule!.content.lessons.count {
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            lessonDescription = addStyling(currentLesson!.explanation)
        } else {
            currentLesson = nil
            currentLessonIndex = 0
        }
    }
    
    // MARK: Styling Code
    // Chnage string to NSAttributed string
    private func addStyling(_ htmlString:String) -> NSAttributedString {
        var resultString = NSAttributedString()
        var data = Data()
        //Add styling
        if styleData != nil {
            data.append(self.styleData!)
        }
        
        //Add html
        data.append(Data(htmlString.utf8))
        
        //convert to NSAttributed
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            resultString = attributedString
        }
        
        return resultString
    }
}
