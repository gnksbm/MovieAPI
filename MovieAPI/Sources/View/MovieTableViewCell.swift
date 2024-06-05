//
//  MovieTableViewCell.swift
//  MovieAPI
//
//  Created by gnksbm on 6/5/24.
//

import UIKit

import SnapKit

final class MovieTableViewCell: UITableViewCell {
    private let nameLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(data: String) {
        nameLabel.text = data
    }
    
    private func configureUI() {
        [nameLabel].forEach {
            contentView.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).offset(20)
            make.trailing.bottom.equalTo(contentView).offset(-20)
        }
    }
}
