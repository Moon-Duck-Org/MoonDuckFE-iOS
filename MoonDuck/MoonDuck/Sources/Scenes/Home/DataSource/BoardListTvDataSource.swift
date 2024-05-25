//
//  HomeListTvDataSource.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import Foundation
import UIKit

final class BoardListTvDataSource: NSObject {
    fileprivate let presenter: HomePresenter
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
    }
    
    func configure(with tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: BoardListTvCell.className, bundle: nil), forCellReuseIdentifier: BoardListTvCell.className)
    }
}

extension BoardListTvDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfBoard
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: BoardListTvCell = tableView.dequeueReusableCell(withIdentifier: BoardListTvCell.className, for: indexPath) as? BoardListTvCell {
            let board = presenter.board(at: indexPath.row)
            cell.configure(with: board)
            return cell
        }
        return UITableViewCell()
    }
}

extension BoardListTvDataSource: UITableViewDelegate {
    
}
