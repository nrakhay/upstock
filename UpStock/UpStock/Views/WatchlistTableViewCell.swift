//
//  WatchlistTableViewCell.swift
//  UpStock
//
//  Created by Nurali Rakhay on 09.03.2023.
//

import UIKit

protocol WatchlistTableViewCellDelegate: AnyObject {
    func didUpdateMaxWidth()
}

class WatchlistTableViewCell: UITableViewCell {
    static let identifier = "WatchlistTableViewCell"
    
    weak var delegate: WatchlistTableViewCellDelegate?
    
    static let preferredHeight: CGFloat = 60
    
    struct ViewModel {
        let symbol: String
        let companyName: String
        let price: String // formatted
        let changeColor: UIColor // red or green
        let changePercentage: String
        let chartViewModel: StockChartView.ViewModel
    }
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 3
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private let miniChartView: StockChartView = {
        let chart = StockChartView()
        chart.clipsToBounds = true
        return chart
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        addSubviews(
            symbolLabel,
            companyLabel,
            priceLabel,
            changeLabel,
            miniChartView
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        companyLabel.text = nil
        symbolLabel.text = nil
        priceLabel.text = nil
        changeLabel.text = nil
        miniChartView.reset()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        symbolLabel.sizeToFit()
        companyLabel.sizeToFit()
        priceLabel.sizeToFit()
        changeLabel.sizeToFit()
        
        let yStart: CGFloat = (contentView.height - symbolLabel.height - companyLabel.height) / 2
        symbolLabel.frame = CGRect(
            x: separatorInset.left,
            y: yStart,
            width: symbolLabel.width,
            height: symbolLabel.height
        )
        
        companyLabel.frame = CGRect(
            x: separatorInset.left,
            y: symbolLabel.bottom,
            width: companyLabel.width,
            height: companyLabel.height
        )
            
        let currentWidth = max(
            max(priceLabel.width, changeLabel.width),
            WatchListVC.maxChangeWidth
        )
        
        if currentWidth > WatchListVC.maxChangeWidth {
            WatchListVC.maxChangeWidth = currentWidth + 3
            delegate?.didUpdateMaxWidth()
        }
        
        priceLabel.frame = CGRect(
            x: contentView.width - 10 - currentWidth,
            y: (contentView.height - priceLabel.height - changeLabel.height) / 2,
            width: currentWidth,
            height: priceLabel.height
        )
        
        changeLabel.frame = CGRect(
            x: contentView.width - 10 - currentWidth,
            y: priceLabel.bottom,
            width: currentWidth,
            height: changeLabel.height + 2
        )
        
        miniChartView.frame = CGRect(
            x: priceLabel.left - (contentView.width / 3) - 5,
            y: 6,
            width: contentView.width / 3,
            height: contentView.height - 12)
    }
    
    public func configure(with viewModel: ViewModel) {
        symbolLabel.text = viewModel.symbol
        companyLabel.text = viewModel.companyName
        priceLabel.text = viewModel.price
        changeLabel.text = viewModel.changePercentage
        changeLabel.backgroundColor = viewModel.changeColor
    }
}
