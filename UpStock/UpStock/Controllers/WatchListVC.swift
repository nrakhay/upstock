//
//  ViewController.swift
//  UpStock
//
//  Created by Nurali Rakhay on 28.02.2023.
//

import UIKit

class WatchListVC: UIViewController {
    private var searchTimer: Timer?
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSearchController()
        setupTitleView()
        setupChild()
    }

    //MARK: - Private
    
    private func setupChild() {
        let vc = PanelViewController()
        addChild(vc)
        
        view.addSubview(vc.view)
        vc.view.frame = CGRect(x: 0, y: view.height/2, width: view.width, height: view.height)
        vc.didMove(toParent: self)
    }
    
    private func setupTitleView() {
        let titleView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.width,
                height: navigationController?.navigationBar.height ?? 100
            )
        )
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: titleView.width - 20, height: titleView.height))
        label.text = "Stocks"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        titleView.addSubview(label)
        navigationItem.titleView = titleView
    }
    
    private func setupSearchController() {
        let resultVC = SearchResultsVC()
        let searchVC = UISearchController(searchResultsController: resultVC)
        
        resultVC.delegate = self
        searchVC.searchResultsUpdater = self
        
        navigationItem.searchController = searchVC
    }
}

extension WatchListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              let resultsVC = searchController.searchResultsController as? SearchResultsVC,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        searchTimer?.invalidate()
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
            APICaller.shared.search(query: query) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        resultsVC.update(with: response.result)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        resultsVC.update(with: [])
                    }
                    
                    print(error)
                }
            }
        })
    }
}

extension WatchListVC: SearchResultsVCDelegate {
    func searchResultsVCDidSelect(searchResult: SearchResults) {
        navigationItem.searchController?.searchBar.resignFirstResponder()
        let vc = StockInfoVC()
        
        let navVC = UINavigationController(rootViewController: vc)
        vc.title = searchResult.description
        present(navVC, animated: true)
    }
    
    
}

