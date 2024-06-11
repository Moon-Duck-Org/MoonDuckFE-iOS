//
//  CategorySearchDataSource.swift
//  MoonDuck
//
//  Created by suni on 6/11/24.
//

import UIKit

final class CategorySearchDataSource: NSObject {
    fileprivate let presenter: CategorySearchPresenter
    
    init(presenter: CategorySearchPresenter) {
        self.presenter = presenter
    }

    func configure(with tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: CategorySearchTableViewCell.className, bundle: nil), forCellReuseIdentifier: CategorySearchTableViewCell.className)
    }
}

// MARK: - UITableViewDataSource
extension CategorySearchDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfCategories
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: CategorySearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: CategorySearchTableViewCell.className, for: indexPath) as? CategorySearchTableViewCell {
            if let category = presenter.category(at: indexPath.row) {
                cell.configure(with: category)
            }
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension CategorySearchDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        presenter.selectBoard(at: indexPath.row)
    }
}
