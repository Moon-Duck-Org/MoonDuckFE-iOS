//
//  HomeReviewDataSource.swift
//  MoonDuck
//
//  Created by suni on 6/23/24.
//

import UIKit

final class HomeReviewDataSource: NSObject {
    fileprivate let presenter: HomePresenter
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
    }

    func configure(with tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
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
                let reviewOptionHandler: (() -> Void)? = presenter.reviewOptionHandler(for: review)
                let reviewTappedHandler: (() -> Void)? = presenter.reviewTappedHandler(for: review)
                cell.configure(with: review, optionButtonHandler: reviewOptionHandler, tappedHandler: reviewTappedHandler)
            }
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension HomeReviewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectReview(at: indexPath.row)
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension HomeReviewDataSource: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // 셀이 prefetch 되었을 때 호출되는 메서드
        guard let lastIndexPath = indexPaths.last else { return }
        let lastIndex = lastIndexPath.row
        
        // 마지막 인덱스가 현재 로드된 데이터의 갯수보다 많으면 다음 페이지를 로드
        if lastIndex > presenter.numberOfReviews - 2 {
            presenter.loadNextReviews()
        }
    }
}
