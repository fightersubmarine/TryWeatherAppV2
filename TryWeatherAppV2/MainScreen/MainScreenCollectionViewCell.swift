//
//  MainScreenCollectionViewCell.swift
//  TryWeatherAppV2
//
//  Created by Алина on 08.05.2024.
//

import UIKit

private extension CGFloat {
    static let cornerRadius = 10.0
    static let borderWidth = 3.0
}

final class MainScreenCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Lazy var
    
     lazy var dataCellLabel: UILabel = {
        let label = UILabel.customLabelForCell(text: placeholders.placeholderForLabel)
        label.sizeToFit()
        return label
    }()
    
     lazy var tempCellLabel: UILabel = {
         let label = UILabel.customLabelForCell(text: placeholders.placeholderForLabel)
         label.sizeToFit()
         return label
     }()
    
     lazy var imageCellLabel: UILabel = {
        UILabel.customLabelForCell(text: placeholders.placeholderForLabel)
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSelf()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - UI Configuration
    
    private func setupSelf() {
        self.backgroundColor = UIColor.clear
        self.layer.borderWidth = CGFloat.borderWidth
        self.layer.cornerRadius = CGFloat.cornerRadius
        self.layer.borderColor = UIColor.borderColor.cgColor
        addSubview(dataCellLabel)
        addSubview(tempCellLabel)
        addSubview(imageCellLabel)
    }
    
    private func setupLayout() {
        dataCellLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constraint.constant12)
            $0.leading.trailing.equalToSuperview().inset(Constraint.constant8)
        }
        
        imageCellLabel.snp.makeConstraints {
            $0.top.equalTo(dataCellLabel.snp.bottom).offset(Constraint.constant12)
            $0.leading.trailing.equalToSuperview().inset(Constraint.constant8)
            $0.centerX.equalToSuperview()
        }
        
        tempCellLabel.snp.makeConstraints {
            $0.top.equalTo(imageCellLabel.snp.bottom).offset(Constraint.constant12)
            $0.leading.trailing.equalToSuperview().inset(Constraint.constant8)
            $0.bottom.equalToSuperview().inset(Constraint.constant12)
        }
    }
}
