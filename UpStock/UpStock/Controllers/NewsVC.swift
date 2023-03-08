//
//  PopularNewsVC.swift
//  UpStock
//
//  Created by Nurali Rakhay on 28.02.2023.
//

import UIKit

class NewsVC: UIViewController {
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
    let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self,
                       forCellReuseIdentifier: NewsTableViewCell.identifier)
        table.register(NewsHeaderView.self,
                       forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        table.backgroundColor = .clear
        return table
    }()
    
    //MARK: - Properties
    private var type: Type
    private var stories = [NewsStory]()
    
    
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
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    //MARK: - Private
    private var tableHeaderView = UIView()
    
    private func setupTable() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func fetchNews() {
        APICaller.shared.news(for: .topStories) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
                DispatchQueue.main.async {
                    self?.stories = response
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private func open(url: URL) {
        
    }

}

extension NewsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.identifier,
            for: indexPath
        ) as? NewsTableViewCell else {
            fatalError()
        }
        
        cell.configure(with: .init(model: stories[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: NewsHeaderView.identifier
        ) as? NewsHeaderView else {
            return nil
        }
                
        header.configure(with: .init(
            title: self.type.title,
            shouldShowAddButton: false
        ))
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
