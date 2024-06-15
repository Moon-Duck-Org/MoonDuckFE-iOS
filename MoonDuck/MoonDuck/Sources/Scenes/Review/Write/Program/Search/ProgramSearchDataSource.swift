//
//  ProgramSearchDataSource.swift
//  MoonDuck
//
//  Created by suni on 6/11/24.
//

import UIKit

final class ProgramSearchDataSource: NSObject {
    fileprivate let presenter: ProgramSearchPresenter
    
    init(presenter: ProgramSearchPresenter) {
        self.presenter = presenter
    }

    func configure(with tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: ProgramSearchTableViewCell.className, bundle: nil), forCellReuseIdentifier: ProgramSearchTableViewCell.className)
    }
}

// MARK: - UITableViewDataSource
extension ProgramSearchDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfPrograms
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: ProgramSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: ProgramSearchTableViewCell.className, for: indexPath) as? ProgramSearchTableViewCell {
            if let category = presenter.program(at: indexPath.row) {
                cell.configure(with: category)
            }
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension ProgramSearchDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        presenter.selectBoard(at: indexPath.row)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        presenter.scrollViewWillBeginDragging()
    }
}
