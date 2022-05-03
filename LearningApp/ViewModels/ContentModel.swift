//
//  ContentModel.swift
//  LearningApp
//
//  Created by Johnathan Lee on 4/20/22.
//

import Foundation
import Firebase

class ContentModel: ObservableObject {
    
    let db = Firestore.firestore()
    
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
//        getRemoteData()
        getModules()
    }
    
    // MARK: Data Methods
    
    func getLocalData() {
        
        // no longer needed because data is in the Firestore database
//        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
//
//        do {
//
//            let data = try Data(contentsOf: jsonUrl!)
//            let decoder = JSONDecoder()
//
//            do {
//
//                let moduleData = try decoder.decode([Module].self, from: data)
//
//                self.modules = moduleData
//
//            } catch {
//                print(error)
//            }
//        } catch {
//            print(error)
//        }
        
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
                
                DispatchQueue.main.async {
                    self.modules += modules
                }
                
            } catch {
                print(error)
            }
        }
        
        // Kick off data task
        dataTask.resume()
    }
    
    func getModules() {
        let collection = db.collection("modules")
        
        collection.getDocuments { snapshot, error in
            
            var modules = [Module]()
            
            if error == nil && snapshot != nil {
                for doc in snapshot!.documents {
                    var m = Module()
                    
                    m.id = doc["id"] as? String ?? UUID().uuidString
                    m.category = doc["category"] as? String ?? ""
                    
                    let contentMap = doc["content"] as! [String:Any]
                    m.content.id = contentMap["id"] as? String ?? ""
                    m.content.description = contentMap["description"] as? String ?? ""
                    m.content.image = contentMap["image"] as? String ?? ""
                    m.content.time = contentMap["time"] as? String ?? ""
                    
                    let testMap = doc["test"] as! [String:Any]
                    m.test.id = testMap["id"] as? String ?? ""
                    m.test.description = testMap["description"] as? String ?? ""
                    m.test.image = testMap["image"] as? String ?? ""
                    m.test.time = testMap["time"] as? String ?? ""
                    
                    modules.append(m)
                }
            }
            
            DispatchQueue.main.async {
                self.modules = modules
            }
        }
        
    }
    
    // Notice the completion handler
    func getLessons(module: Module, completion: @escaping () -> Void) {
        let collection = db.collection("modules").document(module.id).collection("lessons")
        
        collection.getDocuments {
            snapshot, error in
            if error == nil && snapshot != nil {
                var lessons = [Lesson]()
                
                for doc in snapshot!.documents {
                    var l = Lesson()
                    
                    l.id = doc["id"] as? String ?? UUID().uuidString
                    l.title = doc["title"] as? String ?? ""
                    l.explanation = doc["explanation"] as? String ?? ""
                    l.duration = doc["duration"] as? String ?? ""
                    l.video = doc["video"] as? String ?? ""
                    
                    lessons.append(l)
                }
                
                for (index, m) in self.modules.enumerated() {
                    if m.id == module.id {
                        // Cannot do the following, module is a struct, so it's a copy
    //                    m.content.lessons = lessons
                        self.modules[index].content.lessons = lessons
                        
                        // Call the completion closure
                        completion()
                    }
                }
            }
        }
    }
    
    func getQuestions(module: Module, completion: @escaping () -> Void) {
        let collection = db.collection("modules").document(module.id).collection("questions")
        
        collection.getDocuments {
            snapshot, error in
            if error == nil && snapshot != nil {
                var questions = [Question]()
                
                for doc in snapshot!.documents {
                    var q = Question()
                    
                    q.id = doc["id"] as? String ?? UUID().uuidString
                    q.content = doc["content"] as? String ?? ""
                    q.correctIndex = doc["correctIndex"] as? Int ?? 0
                    q.answers = doc["answers"] as? [String] ?? [String]()
                    
                    questions.append(q)
                }
                
                for (index, m) in self.modules.enumerated() {
                    if m.id == module.id {
                        self.modules[index].test.questions = questions
                        completion()
                    }
                }
            }
        }
    }
    
    // MARK: Module navigation methods
    
    func beginModule(_ moduleId:String) {
        
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
    
    func beginTest(_ moduleId:String) {
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
