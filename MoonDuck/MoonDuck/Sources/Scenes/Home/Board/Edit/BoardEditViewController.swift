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
}

class BoardEditViewController: UIViewController, BoardEditView, Navigatable {
    
    @IBOutlet weak private var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak private var titleTextField: TextField!
    @IBOutlet weak private var contentTextView: TextView!
    
    @IBOutlet weak private var linkTextField: TextField!
    @IBOutlet weak private var imageCollectionView: UICollectionView!
    
    @IBOutlet weak private var titleCountLabel: UILabel!
    @IBOutlet weak private var contentCountLabel: UILabel!
    
    @IBAction private func cancelButtonTap(_ sender: Any) {
        navigator.pop(sender: self)
    }
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    let presenter: BoardEditPresenter
    var navigator: Navigator!
    
    init(navigator: Navigator, presenter: BoardEditPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        super.init(nibName: BoardEditViewController.className, bundle: Bundle(for: BoardEditViewController.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.viewDidLoad()
        
        titleTextField.delegate = self
        contentTextView.delegate = self
        linkTextField.delegate = self
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
        contentTextView.text = board.content
        
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
}

// MARK: - UITextFieldDelegate
extension BoardEditViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        let currentText = titleTextField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changeText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return presenter.checkTitle(current: currentText, change: changeText)
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
        
        return presenter.checkTitle(current: currentText, change: changeText)
    }
}
