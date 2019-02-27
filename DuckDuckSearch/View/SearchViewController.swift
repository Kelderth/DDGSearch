//
//  SearchViewController.swift
//  DuckDuckSearch
//
//  Created by MCS on 2/22/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let vm = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let searchNib = UINib(nibName: "SearchHeader", bundle: Bundle.main)
        tableView.register(searchNib, forHeaderFooterViewReuseIdentifier: "SearchHeader")
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }

    func downloadResult(for term: String){
        vm.downloadResult(for: vm.setURL(for: term)) { (result) in
            if result != nil {
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.vm.saveSearchTerm(term: term, completion: {
                        self.performSegue(withIdentifier: "Result", sender: nil)
                        
                        if !self.vm.filterSearchTerm(term: term) {
                            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .left)
                        }
                        
                        self.tableView.reloadData()
                    })
                }
            } else {
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.searchMessageAlertResponse(term: term)
                }
            }
        }
    }
    
    func searchMessageAlertResponse(term: String) {
        let title: String = "⚠️ DDG Search"
        let message: String = "No definition could be found for \n\"\(term.uppercased())\" \ntry searching for something else?"
        
        let alertMessage: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissOption: UIAlertAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertMessage.addAction(dismissOption)
        
        present(alertMessage, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ResultViewController
        vc.textDescription = vm.getDefinition()
        vc.textTitle = vm.getTitle()
        vc.imageToLoad = vm.getImageURL()
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.searchTermArraySize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? SearchTableViewCell else { return UITableViewCell() }
        
        cell.searchTermLabel.text = vm.searchTerms[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let term: String = vm.filteredResultSearchTerm(index: indexPath.row)
      
        downloadResult(for: term)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchHeader") as? SearchHeader else { return UITableViewHeaderFooterView() }
        
        header.searchBar.becomeFirstResponder()
        
        header.searchBar.delegate = self
        
        return header
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        activityIndicatorView.startAnimating()
        
        downloadResult(for: searchBar.text!)
        searchBar.text = ""
        searchBar.becomeFirstResponder()
    }
}
