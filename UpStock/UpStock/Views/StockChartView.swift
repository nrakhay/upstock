//
//  StockChartView.swift
//  UpStock
//
//  Created by Nurali Rakhay on 09.03.2023.
//

import UIKit
import Charts

class StockChartView: UIView {
    struct ViewModel {
        let data: [Double]
        let showLegend: Bool
        let showAxis: Bool
    }
    
    var chartData = [ChartDataEntry]()
    
    var lineChartView: LineChartView = {
        let lineChart = LineChartView()
        
        return lineChart
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        setupChart()
        self.addSubview(lineChartView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineChartView.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    func reset() {
        
    }
    
    func configure(with viewModel: ViewModel) {
        for entry in viewModel.data {
            chartData.append(ChartDataEntry(x: entry, y: entry))
        }
    }
    
    private func setupChart() {
        lineChartView.delegate = self
        
        var entries = [ChartDataEntry]()
        
        for x in 0..<10 {
            entries.append(ChartDataEntry(x: Double(x), y: Double(x)))
        }
        
        let set = LineChartDataSet(entries: entries)
//        set.colors = ChartColorTemplates.colorful()
        set.drawCirclesEnabled = false
        set.drawValuesEnabled = false
        
        let data = LineChartData(dataSet: set)
        
        lineChartView.data = data
    }
}

extension StockChartView: ChartViewDelegate {
    
}

