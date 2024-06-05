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
    private var list = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var tableView = {
        let tableView = UITableView()
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
                        list = movieData.titleList
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
        }
    }
    
    private func configureUI() {
        [tableView].forEach {
            view.addSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
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
        let data = "\(indexPath.row + 1). \(list[indexPath.row])"
        cell.configureCell(data: data)
        return cell
    }
}
