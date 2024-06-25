//
//  SortModel.swift
//  MoonDuck
//
//  Created by suni on 6/25/24.
//

import Foundation

protocol SortModelDelegate: AnyObject {
    func sort(_ model: SortModel, didSelect sortOption: Sort)
    func sort(_ model: SortModel, didReload sortOption: Sort)
}

protocol SortModelType: AnyObject {
    // Data
    var delegate: SortModelDelegate? { get set }
    var sortOptions: [Sort] { get }
    var numberOfSortOptions: Int { get }
    var indexOfSelectedSortOption: Int { get }
    var selectedSortOption: Sort { get }
    
    func sortOption(at index: Int) -> Sort?
    
    // Action
    func selectSortOption(_ index: Int)
    func reloadSortOption()
}

class SortModel: SortModelType {
    // MARK: - Data
    weak var delegate: SortModelDelegate?
    
    var sortOptions: [Sort] = [.latestOrder, .oldestFirst, .ratingOrder]
    
    var numberOfSortOptions: Int {
        return sortOptions.count
    }
    
    var indexOfSelectedSortOption: Int = 0
    
    var selectedSortOption: Sort {
        if let sort = sortOption(at: indexOfSelectedSortOption) {
            return sort
        } else {
            return Sort.latestOrder
        }
    }
    
    func sortOption(at index: Int) -> Sort? {
        if index < sortOptions.count {
            return sortOptions[index]
        }
        return nil
    }
    
    // MARK: - Action
    func selectSortOption(_ index: Int) {
        if indexOfSelectedSortOption == index { return }
        
        indexOfSelectedSortOption = index
        delegate?.sort(self, didSelect: selectedSortOption)
    }
    
    func reloadSortOption() {
        indexOfSelectedSortOption = 0
        delegate?.sort(self, didReload: selectedSortOption)
    }
}
