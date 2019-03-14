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
    var searchTermsBackup: [String] = [String]()
    var searchBarText: String = ""
    let ns = NetworkService()
    let dp = DataPersistenceService()
    
    func setURL(for term: String?) -> URL? {
        
        guard let baseURL = URL(string: self.baseURL), let searchTerm = term, var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else { return nil }
        
        let parameters: [String: String] = ["q": searchTerm, "format": "json", "pretty": "1", "no_html": "1", "skip_disambig": "1"]
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
    
    func loadDataFromDP() {
        searchTerms = dp.loadData()!
        searchTermsBackup = dp.loadData()!
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
    
    func getSearchBarText() -> String {
        return searchBarText
    }
    
    func emptySearchBatText() -> String {
        searchBarText = ""
        return searchBarText
    }
    
    func searchTermArraySize() -> Int {
        return searchTerms.count
    }
    
    func restartTermArrayContent() {
        searchTerms = searchTermsBackup
    }
    
    func termsArrayContent() -> [String]? {
        
        return searchTerms
    }
    
    func saveSearchTerm(term: String, completion: @escaping (Bool) -> Void) {
        searchTerms = searchTermsBackup
        
        if searchTerms.contains(term) {
            completion(false)
            return
        }
        
        searchTerms.insert(term, at: 0)
        searchTermsBackup.insert(term, at: 0)
        
        searchBarText = ""
        dp.saveData(term: term)
        completion(true)
    }
    
    func deleteFromSearchTerm(index: Int, completion: @escaping (Bool) -> Void) {
        if index > searchTerms.count {
            completion(false)
            return
        }
                
        dp.deleteData(term: searchTerms[index])
        searchTerms.remove(at: index)
        searchTermsBackup = searchTerms
        completion(true)
    }
    
    func searchTermExistsInTable(term: String) -> Bool {
        return searchTerms.contains(term)
    }
    
    func filteredResultSearchTerm(index: Int) -> String {
        return searchTerms[index]
    }
    
    func filterTableViewContent(text: String, completion: @escaping (Bool) -> Void) {
        var searchTermsFiltered: [String]?
        searchBarText = text
        
        searchTermsFiltered = searchTermsBackup.filter({$0.contains(text)})
                
        if searchTermsFiltered?.isEmpty == false && text != "" {
            searchTerms = searchTermsFiltered!
            completion(true)
        } else {
            searchTerms = searchTermsBackup
            completion(false)
        }
    }
}
