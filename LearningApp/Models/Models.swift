//
//  Content.swift
//  LearningApp
//
//  Created by Johnathan Lee on 4/20/22.
//

import Foundation

struct Module: Identifiable, Decodable {
    var id: String = ""
    var category: String = ""
    var content:Content = Content()
    var test:Test = Test()
}

struct Content: Identifiable, Decodable {
    var id: String = ""
    var image: String = ""
    var time: String = ""
    var description: String = ""
    var lessons: [Lesson] = [Lesson]()
}

struct Lesson: Identifiable, Decodable {
    var id: String = ""
    var title: String = ""
    var video: String = ""
    var duration: String = ""
    var explanation: String = ""
}

struct Test: Identifiable, Decodable {
    var id: String = ""
    var image: String = ""
    var time: String = ""
    var description: String = ""
    var questions: [Question] = [Question]()
}

struct Question: Identifiable, Decodable {
    var id: String = ""
    var content:String = ""
    var correctIndex: Int = 0
    var answers:[String] = [String]()
}
