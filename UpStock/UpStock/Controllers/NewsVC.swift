//
//  PopularNewsVC.swift
//  UpStock
//
//  Created by Nurali Rakhay on 28.02.2023.
//

import UIKit

class NewsVC: UIViewController {
    var tableView: UITableView {
        let table = UITableView()
        
        return table
    }
    
    private let type: Type
    
    enum `Type` {
        case topStories
        case company(symbol: String)
        
        var title: String {
            switch self {
            case .topStories:
                return "Top Stories"
            case .company(let symbol):
                return symbol.uppercased()
            }
        }
    }
    
    //MARK: - Init
    
    init(type: Type) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        fetchNews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: - Private
    
    private func setupTable() {
        
    }

    private func fetchNews() {
        
    }
    
    private func open(url: URL) {
        
    }

}
