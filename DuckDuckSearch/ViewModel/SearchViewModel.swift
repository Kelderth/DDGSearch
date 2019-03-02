//
//  SearchViewModel.swift
//  DuckDuckSearch
//
//  Created by MCS on 2/24/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit

class SearchViewModel {
    
    // MARK: - Properties
    let baseURL: String = "https://api.duckduckgo.com"
    var searchResult: DDGModel?
    var searchTerms: [String] = [String]()
    let ns = NetworkService()
    let dp = DataPersistenceService()
    
    func setURL(for term: String?) -> URL? {
        let baseURL: URL! = URL(string: self.baseURL)
        
        var components: URLComponents! = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let parameters: [String: String] = ["q": term!, "format": "json", "pretty": "1", "no_html": "1", "skip_disambig": "1"]
        components.queryItems = parameters.compactMap({URLQueryItem(name: $0.key, value: $0.value)})
        guard let url = components.url else { return nil }
        
        return url
    }
    
    func downloadResult(for term: URL?, completion: @escaping (DDGModel?) -> Void) {
        guard let term = term else {
            completion(nil)
            return
        }
        
        ns.performSearch(for: term) { (data) in
            guard let jsonData = data else { return }
            
            let definition = try? JSONDecoder().decode(DDGModel.self, from: jsonData)
                
            if let definition = definition, definition.resultType == .article {
                self.searchResult = definition
                completion(definition)
            } else {
                completion(nil)
            }
        }
    }
    
    func downloadImageAsset(from link: URL?, completion: @escaping (UIImage?) -> Void){
        let link: String = "\(link!)"
        ns.getImage(for: link) { (image) in
            guard let image = image else { return }
                
            completion(image)
        }
    }
    
    func getTitle() -> String {
        return (searchResult?.title)!
    }
    
    func getDefinition() -> String {
        return (searchResult?.description)!
    }
    
    func getImageURL() -> URL? {
        return (searchResult?.imageURL)!
    }
    
    func searchTermArraySize() -> Int {
        searchTerms = dp.loadData()!
        return searchTerms.count
    }
    
    func termsArrayContent() -> [String]? {
        return searchTerms
    }
    
    func saveSearchTerm(term: String, completion: @escaping () -> Void) {
        if searchTerms.contains(term) {
            completion()
            return
        }
        
        searchTerms.insert(term, at: 0)
        dp.saveData(term: term)
        completion()
    }
    
    func deleteFromSearchTerm(index: Int) {
        dp.deleteData(term: searchTerms[index])
        searchTerms.remove(at: index)
    }
    
    func filterSearchTerm(term: String) -> Bool {
        return searchTerms.contains(term)
    }
    
    func filteredResultSearchTerm(index: Int) -> String {
        return searchTerms[index]
    }
}
