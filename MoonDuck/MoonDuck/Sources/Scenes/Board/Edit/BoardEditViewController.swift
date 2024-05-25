//
//  BoardEditViewController.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import UIKit

protocol BoardEditView: NSObject {
    func updateData(board: Review)
    func updateCountTitle(_ count: Int)
    func updateCountContent(_ count: Int)
    
    func keyboardWillShow(with keyboardInfo: UIKeyboardInfo)
    func keyboardWillHide(with keyboardInfo: UIKeyboardInfo)
    
    func reloadCategory()
    func popView()
    func updateRating(at rating: Int)
}

class BoardEditViewController: UIViewController, BoardEditView, Navigatable {
    
    @IBOutlet weak private var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak private var titleTextField: TextField!
    @IBOutlet weak private var contentTextView: TextView!
    
    @IBOutlet weak private var linkTextField: TextField!
    @IBOutlet weak private var imageCollectionView: UICollectionView!
    
    @IBOutlet weak private var titleCountLabel: UILabel!
    @IBOutlet weak private var contentCountLabel: UILabel!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak private var ratingButton1: UIButton!
    @IBOutlet weak private var ratingButton2: UIButton!
    @IBOutlet weak private var ratingButton3: UIButton!
    @IBOutlet weak private var ratingButton4: UIButton!
    @IBOutlet weak private var ratingButton5: UIButton!
    
    @IBAction private func cancelButtonTap(_ sender: Any) {
        navigator.pop(sender: self)
    }
    
    @IBAction private func saveButtonTap(_ sender: Any) {
        presenter.saveData()
    }
    
    let presenter: BoardEditPresenter
    var navigator: Navigator!
    let categoryDataSource: ReviewEditCategoryCvDataSource
    
    init(navigator: Navigator, presenter: BoardEditPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        self.categoryDataSource = ReviewEditCategoryCvDataSource(presenter: presenter)
        super.init(nibName: BoardEditViewController.className, bundle: Bundle(for: BoardEditViewController.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.viewDidLoad()
        
        categoryDataSource.configure(with: categoryCollectionView)
        
        titleTextField.delegate = self
        contentTextView.delegate = self
        linkTextField.delegate = self
//        
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        view.addGestureRecognizer(gesture)
        ratingButton1.addTarget(self, action: #selector(tabRatingButton(_:)), for: .touchUpInside)
        ratingButton2.addTarget(self, action: #selector(tabRatingButton(_:)), for: .touchUpInside)
        ratingButton3.addTarget(self, action: #selector(tabRatingButton(_:)), for: .touchUpInside)
        ratingButton4.addTarget(self, action: #selector(tabRatingButton(_:)), for: .touchUpInside)
        ratingButton5.addTarget(self, action: #selector(tabRatingButton(_:)), for: .touchUpInside)
    }

    @objc
    private func tabRatingButton(_ sender: UIButton) {
        presenter.tabRatingButton(at: sender.tag)
    }
    
    @objc 
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if titleTextField.isFirstResponder {
            titleTextField.resignFirstResponder()
        }
        
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
        
        if linkTextField.isFirstResponder {
            linkTextField.resignFirstResponder()
        }
        presenter.viewWillDisappear()
         
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func keyboardWillShow(with keyboardInfo: UIKeyboardInfo) {
        view.layoutIfNeeded()
        scrollViewBottomConstraint.constant = keyboardInfo.frame.size.height
        UIView.animate(withDuration: keyboardInfo.animationDuration,
                       delay: 0,
                       options: keyboardInfo.animationCurve,
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }

    func keyboardWillHide(with keyboardInfo: UIKeyboardInfo) {
        view.layoutIfNeeded()
        scrollViewBottomConstraint.constant = 0
        UIView.animate(withDuration: keyboardInfo.animationDuration,
                       delay: 0,
                       options: keyboardInfo.animationCurve,
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }
    
    func updateData(board: Review) {
        
        
        titleTextField.text = board.title
        updateCountTitle(board.title.count)
        
        contentTextView.text = board.content
        updateCountContent(board.content.count)
        
        updateRating(at: board.rating)
        
        if let link = board.link {
            linkTextField.text = link
        }
    }
    func updateCountTitle(_ count: Int) {
        titleCountLabel.text = "\(count)/40"
    }
    
    func updateCountContent(_ count: Int) {
        contentCountLabel.text = "\(count)/500"
    }
    
    func reloadCategory() {
        categoryCollectionView.reloadData()
    }
    
    func popView() {
        navigator.pop(sender: self)
    }
    
    func updateRating(at rating: Int) {
        ratingButton1.isSelected = rating > 0
        ratingButton2.isSelected = rating > 1
        ratingButton3.isSelected = rating > 2
        ratingButton4.isSelected = rating > 3
        ratingButton5.isSelected = rating > 4
    }
}

// MARK: - UITextFieldDelegate
extension BoardEditViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        if textField == titleTextField {
            let currentText = titleTextField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let changeText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return presenter.changeTitle(current: currentText, change: changeText)
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

// MARK: - UITextViewDelegate
extension BoardEditViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changeText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return presenter.changeContent(current: currentText, change: changeText)
    }
}
