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
        let pickerView = UIDatePicker()
        pickerView.preferredDatePickerStyle = .wheels
        pickerView.datePickerMode = .date
        return pickerView
    }()
    
    private lazy var textField = {
        let textField = UITextField()
        textField.placeholder = "날짜를 선택해주세요"
        textField.text = API.dailyBoxOffice.yesterday
        textField.inputView = datePicker
        textField.font = .systemFont(ofSize: 20, weight: .medium)
        textField.addTarget(
            self,
            action: #selector(fetchButtonTapped),
            for: .editingDidEndOnExit
        )
        return textField
    }()
    
    private lazy var searchButton = {
        let button = UIButton(configuration: .filled())
        button.configuration?.cornerStyle = .small
        button.configuration?.baseForegroundColor = .systemBackground
        button.configuration?.baseBackgroundColor = .label
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
    
    @objc private func fetchButtonTapped() {
        if let url = API.dailyBoxOffice.getURL(date: datePicker.date) {
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
        
        [textField, searchButton, tableView].forEach {
            view.addSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.leading.equalTo(safeArea).offset(20)
            make.trailing.equalTo(searchButton.snp.leading).offset(-20)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(textField)
            make.trailing.equalTo(safeArea).offset(-20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
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
