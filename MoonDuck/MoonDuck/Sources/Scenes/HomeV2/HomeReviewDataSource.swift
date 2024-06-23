//
//  HomeReviewDataSource.swift
//  MoonDuck
//
//  Created by suni on 6/23/24.
//

import UIKit

final class HomeReviewDataSource: NSObject {
    fileprivate let presenter: V2HomePresenter
    
    init(presenter: V2HomePresenter) {
        self.presenter = presenter
    }

    func configure(with tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: HomeReviewTableViewCell.className, bundle: nil), forCellReuseIdentifier: HomeReviewTableViewCell.className)
    }
}

// MARK: - UITableViewDataSource
extension HomeReviewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfReviews
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: HomeReviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: HomeReviewTableViewCell.className, for: indexPath) as? HomeReviewTableViewCell {
            if let review = presenter.review(at: indexPath.row) {
                cell.configure(with: review)
            }
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension HomeReviewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        presenter.selectProgram(at: indexPath.row)
    }
}
