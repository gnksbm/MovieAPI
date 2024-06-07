//
//  MovieTableViewCell.swift
//  MovieAPI
//
//  Created by gnksbm on 6/5/24.
//

import UIKit

import SnapKit

final class MovieTableViewCell: UITableViewCell {
    private let ratingLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .label
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .systemBackground
        return label
    }()
    
    private let nameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .black)
        return label
    }()
    
    private let dateLabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(data: DailyBoxOfficeList) {
        ratingLabel.text = data.rank
        nameLabel.text = data.movieNm
        dateLabel.text = data.openDt
    }
    
    private func configureUI() {
        [ratingLabel, nameLabel, dateLabel].forEach {
            contentView.addSubview($0)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(20)
            make.width.equalTo(contentView).multipliedBy(0.1)
            make.height.equalTo(ratingLabel.snp.width).multipliedBy(0.5)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.leading.equalTo(ratingLabel.snp.trailing).offset(20)
            make.trailing.equalTo(dateLabel).offset(-20)
            make.bottom.equalTo(contentView).offset(-10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-20)
        }
    }
}
