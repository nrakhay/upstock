//
//  ViewController.swift
//  UpStock
//
//  Created by Nurali Rakhay on 28.02.2023.
//

import UIKit
import FloatingPanel

class WatchListVC: UIViewController {
    private var searchTimer: Timer?
    
    private var panel: FloatingPanelController?
    
    private var watchlistMap: [String: [CandleStick]] = [:] // Models
    
    private var viewModels: [String] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        
        return table
    }()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSearchController()
        setupTableView()
        fetchWatchlistData()
        setupFloatingPanel()
        setupTitleView()
    }

    //MARK: - Private
    
    private func fetchWatchlistData() {
        let symbols = PersistenceManager.shared.watchlist
        
        let group = DispatchGroup()
        
        for symbol in symbols {
            group.enter()
            
            APICaller.shared.marketData(for: symbol) { [weak self] result in
                defer {
                    group.leave()
                }
                
                switch result {
                case .success(let data):
                    let candleSticks = data.candleSticks
                    self?.watchlistMap[symbol] = candleSticks
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.tableView.reloadData()
        }
        
        tableView.reloadData()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupFloatingPanel() {
        let vc = NewsVC(type: .topStories)
        let panel = FloatingPanelController(delegate: self)
        panel.surfaceView.backgroundColor = .secondarySystemBackground
        panel.set(contentViewController: vc)
        panel.addPanel(toParent: self)
        panel.track(scrollView: vc.tableView)
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

extension WatchListVC: FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        navigationItem.titleView?.isHidden = fpc.state == .full
    }
}

extension WatchListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        watchlistMap.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}

