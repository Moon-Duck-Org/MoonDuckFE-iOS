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
        tableView.prefetchDataSource = self
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
        presenter.selectProgram(at: indexPath.row)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        presenter.scrollViewWillBeginDragging()
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension ProgramSearchDataSource: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // 셀이 prefetch 되었을 때 호출되는 메서드
        guard let lastIndexPath = indexPaths.last else { return }
        let lastIndex = lastIndexPath.row
        
        // 마지막 인덱스가 현재 로드된 데이터의 갯수보다 많으면 다음 페이지를 로드
        if lastIndex > presenter.numberOfPrograms - 3 {
            presenter.searchNextProgram()
        }
    }
}
