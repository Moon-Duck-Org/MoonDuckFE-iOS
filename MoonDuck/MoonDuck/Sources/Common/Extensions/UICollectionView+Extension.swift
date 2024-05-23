////
////  UICollectionView+Extension.swift
////  MoonDuck
////
////  Created by suni on 5/23/24.
////
//
//import UIKit
//
//extension UICollectionView {
//    public func register<T: ReusableView>(_ cell: CollectionViewCell<T>.Type) {
//        register(CollectionViewCell<T>.self, forCellWithReuseIdentifier: T.reuseIdentifier)
//    }
//    
//    public func dequeue<T: ReusableView>(_ type: CollectionViewCell<T>.Type, for indexPath: IndexPath) -> CollectionViewCell<T> {
//        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! CollectionViewCell<T>
//    }
//}
//public final class CollectionViewCell<T: ReusableView>: UICollectionViewCell {
//    let view: T = {
//        let view = T(frame: .zero)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    public override func prepareForReuse() {
//        super.prepareForReuse()
//        view.prepareForReuse()
//    }
//
//    public func configure(with configuration: T.Configuration) {
//        view.configure(with: configuration)
//    }
//}
//
//public protocol ReusableView: UIView {
//    associatedtype Configuration
//    static var reuseIdentifier: String { get }
//    func prepareForReuse()
//    func configure(with configuration: Configuration)
//}
//
//extension ReusableView {
//    public static var reuseIdentifier: String {
//        return String(describing: self)
//    }
//}
