//
//  ViewController.swift
//  MovieAPI
//
//  Created by gnksbm on 6/5/24.
//

import UIKit

import Alamofire
import SnapKit

final class ViewController: UIViewController {
    private var list = [DailyBoxOfficeList]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var datePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.addTarget(
            self,
            action: #selector(datePickerChanged),
            for: .valueChanged
        )
        return datePicker
    }()
    
    private let textFieldBackgroundView = UIView()
    
    private lazy var textField = {
        let textField = UITextField()
        textField.placeholder = "날짜를 선택해주세요"
        textField.text = API.dailyBoxOffice.latestDate
        textField.inputView = datePicker
        textField.font = .systemFont(ofSize: 20)
        textField.addTarget(
            self,
            action: #selector(fetchButtonTapped),
            for: .editingDidEndOnExit
        )
        return textField
    }()
    
    private lazy var searchButton = {
        let button = UIButton()
        button.backgroundColor = .label
        button.setTitleColor(.systemBackground, for: .normal)
        button.setTitle("검색", for: .normal)
        button.addTarget(
            self,
            action: #selector(fetchButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(
            MovieTableViewCell.self,
            forCellReuseIdentifier: "MovieTableViewCell"
        )
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchMovieData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottomLayer = CALayer()
        bottomLayer.backgroundColor = UIColor.label.cgColor
        let bottomLayerHeight: CGFloat = 5
        let superBounds = textFieldBackgroundView.bounds
        bottomLayer.frame = CGRect(
            x: superBounds.origin.x,
            y: superBounds.height - bottomLayerHeight,
            width: superBounds.width,
            height: bottomLayerHeight
        )
        textFieldBackgroundView.layer.addSublayer(bottomLayer)
    }
    
    private func fetchMovieData() {
        if let url = API.dailyBoxOffice.url {
            AF.request(url)
                .responseDecodable(
                    of: MovieData.self
                ) { [weak self] response in
                    guard let self else { return }
                    switch response.result {
                    case .success(let movieData):
                        list = movieData.dailyBoxOfficeList
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
        }
    }
    
    @objc private func datePickerChanged(_ sender: UIDatePicker) {
        textField.text = sender.date.formatted(dateFormat: .dailyBoxOffice)
    }
    
    @objc private func fetchButtonTapped() {
        guard let dateString = textField.text else {
            print("텍스트필드 값이 없습니다")
            return
        }
        if let url = API.dailyBoxOffice.getURL(dateString: dateString) {
            AF.request(url)
                .responseDecodable(
                    of: MovieData.self
                ) { [weak self] response in
                    guard let self else { return }
                    switch response.result {
                    case .success(let movieData):
                        list = movieData.dailyBoxOfficeList
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        [textFieldBackgroundView, textField, searchButton, tableView].forEach {
            view.addSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        textFieldBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.leading.equalTo(safeArea).offset(20)
            make.trailing.equalTo(searchButton.snp.leading).offset(-20)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(textFieldBackgroundView).offset(20)
            make.leading.trailing.equalTo(textFieldBackgroundView)
            make.bottom.equalTo(textFieldBackgroundView).offset(-20)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(textFieldBackgroundView).offset(10)
            make.bottom.equalTo(textFieldBackgroundView)
            make.trailing.equalTo(safeArea).offset(-20)
            make.width.equalTo(safeArea).multipliedBy(0.22)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textFieldBackgroundView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(safeArea)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        list.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MovieTableViewCell",
            for: indexPath
        ) as! MovieTableViewCell
        let data = list[indexPath.row]
        cell.configureCell(data: data)
        return cell
    }
}
