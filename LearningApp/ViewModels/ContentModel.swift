//
//  ContentModel.swift
//  LearningApp
//
//  Created by Johnathan Lee on 4/20/22.
//

import Foundation

class ContentModel: ObservableObject {
    
    @Published var modules = [Module]()
    var styleData: Data?
    
    init() {
        getLocalData()
    }
    
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
}
