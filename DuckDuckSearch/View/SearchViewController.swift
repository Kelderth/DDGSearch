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
        
        self.navigationController!.navigationBar.barStyle = .black
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let searchNib = UINib(nibName: "SearchHeader", bundle: Bundle.main)
        tableView.register(searchNib, forHeaderFooterViewReuseIdentifier: "SearchHeader")
        
        vm.loadDataFromDP()
    }

    func downloadResult(for term: String){
        vm.downloadResult(for: vm.setURL(for: term)) { (result) in
            if result != nil {
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.vm.saveSearchTerm(term: term, completion: { _ in
                        self.loadResultViewController()
                        
                        if !self.vm.searchTermExistsInTable(term: term) {
                            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .left)
                        }
                        
                        self.vm.filterTableViewContent(text: self.vm.getSearchBarText(), completion: { _ in
                            self.tableView.reloadData()                            
                        })
                        
                    })
                }
            } else {
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.searchMessageAlertResponse(term: term)
                    self.vm.restartTermArrayContent()
                    self.vm.filterTableViewContent(text: self.vm.emptySearchBatText(), completion: { _ in
                        self.tableView.reloadData()
                    })
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
        
    func loadResultViewController() {
        let vc = ResultViewController()
        
        vc.textDescription = vm.getDefinition()
        vc.textTitle = vm.getTitle()
        vc.imageToLoad = vm.getImageURL()
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.searchTermArraySize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? SearchTableViewCell else { return UITableViewCell() }
        
        cell.searchTermLabel.text = vm.termsArrayContent()![indexPath.row]
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            vm.deleteFromSearchTerm(index: indexPath.row) { (response) in
                if response == true {
                    tableView.deleteRows(at: [IndexPath(item: indexPath.row, section: 0)], with: .fade)
                }
            }
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        activityIndicatorView.startAnimating()
        
        downloadResult(for: searchBar.text!)
        searchBar.becomeFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        vm.filterTableViewContent(text: searchText) { _ in
            self.vm.searchBarText = searchBar.text ?? ""
            self.tableView.reloadData()
        }
    }
}
