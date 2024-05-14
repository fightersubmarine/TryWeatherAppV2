//
//  CityListScreenTableViewCell.swift
//  TryWeatherAppV2
//
//  Created by Алина on 09.05.2024.
//

import UIKit

private extension CGFloat {
    static let fontSizeLabelCell = 35
}

final class CityListScreenTableViewCell: UITableViewCell {
    
    //MARK: - Lazy var
    
    static let id = "CityListScreenTableViewCell"
    
    lazy var cellCityLabel: UILabel = {
        let label = UILabel.customLabelForCell(text: placeholders.placeholderForLabel)
        label.font = UIFont.systemFont(ofSize: CGFloat(CGFloat.fontSizeLabelCell))
        return label
    }()
        
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
        
        private func setupView() {
            selectionStyle = .none
            addSubview(cellCityLabel)
        }
        
        private func setupLayout() {
            cellCityLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.centerX.equalToSuperview()
            }
                        
        }

}
