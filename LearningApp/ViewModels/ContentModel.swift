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
    
    @Published var codeText = NSAttributedString()
    
    var styleData: Data?
    
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    init() {
        getLocalData()
        getRemoteData()
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
    
    func getRemoteData() {
//        let urlString = "https://johlee92.github.io/learningapp-data/data2.json"
        let urlString = "https://codewithchris.github.io/learningapp-data/data2.json"
        let url = URL(string: urlString)
        
        guard url != nil else {
            // couldn't reutnr url
            return
        }
        
        // Create an URLRequest object
        let request = URLRequest(url: url!)
        
        // Get the session and kick off the task
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            // check if there's an error
            guard error == nil else {
                return
            }
            // handle the response
            
            do {
                let decoder = JSONDecoder()
            
                let modules = try decoder.decode([Module].self, from: data!)
                
                self.modules += modules
                
            } catch {
                print(error)
            }
        }
        
        // Kick off data task
        dataTask.resume()
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
        codeText = addStyling(currentLesson!.explanation)
    }
    
    func hasNextLesson() -> Bool {
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
    }
    
    func nextLesson() {
        currentLessonIndex += 1
        
        if currentLessonIndex < currentModule!.content.lessons.count {
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
        } else {
            currentLesson = nil
            currentLessonIndex = 0
        }
    }
    
    func beginTest(_ moduleId:Int) {
        beginModule(moduleId)
        
        // start question at the beginning
        currentQuestionIndex = 0
        
        // if there are questions, set to first ne
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
    }
    
    func nextQuestion() {
        currentQuestionIndex += 1
        
        if currentQuestionIndex < currentModule!.test.questions.count {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        } else {
            currentQuestion = nil
            currentQuestionIndex = 0
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
