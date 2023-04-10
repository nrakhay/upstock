//
//  StockDetailHeaderView.swift
//  UpStock
//
//  Created by Nurali Rakhay on 22.03.2023.
//

import UIKit

class StockDetailHeaderView: UIView {
    private var metricViewModels: [MetricCollectionViewCell.ViewModel] = []
    private var chartViewModel: StockChartView.ViewModel?
    private var symbol: String = ""

    private let chartView = StockChartView()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(MetricCollectionViewCell.self, forCellWithReuseIdentifier: MetricCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubviews(chartView, collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = CGRect(x: 0, y: height - 100, width: width, height: height - 100)
    }
    
    func configure(
        chartViewModel: StockChartView.ViewModel,
        metricsViewModels: [MetricCollectionViewCell.ViewModel]
    ) {
        self.metricViewModels = metricsViewModels
        self.chartViewModel = chartViewModel
        print(chartViewModel)
        collectionView.reloadData()
    }
}

extension StockDetailHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return metricViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = metricViewModels[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MetricCollectionViewCell.identifier, for: indexPath) as? MetricCollectionViewCell
        else {
            fatalError()
        }
        
        cell.configure(with: viewModel)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width/2, height: height/3)
    }
    
}
