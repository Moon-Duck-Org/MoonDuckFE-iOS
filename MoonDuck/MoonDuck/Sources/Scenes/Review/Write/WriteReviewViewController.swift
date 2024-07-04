//
//  WriteReviewViewController.swift
//  MoonDuck
//
//  Created by suni on 6/15/24.
//

import UIKit
import PhotosUI

protocol WriteReviewView: BaseView {
    // UI Logic
    func updateProgramInfo(for category: Category, with title: String, and subTitle: String)
    func updateTestField(for title: String, with content: String, and link: String?)
    func updateTitleCountLabelText(with count: String)
    func updateContentCountLabelText(with count: String)
    func updateRating(for rating: Int)
    func showSelectImageSheet()
    func reloadImages()
    
    // Navigation
    func backToHome()
}

class WriteReviewViewController: BaseViewController, WriteReviewView, Navigatable {
    
    var navigator: Navigator?
    let presenter: WriteReviewPresenter
    private let imageDataSource: WriteImageDataSource
    
    // @IBOutlet
    @IBOutlet private weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var programTitleLabel: UILabel!
    @IBOutlet private weak var programSubTitleLabel: UILabel!
    
    @IBOutlet private weak var titleTextField: TextField! {
        didSet {
            titleTextField.delegate = self
        }
    }
    @IBOutlet private weak var titleCountLabel: UILabel!
    
    @IBOutlet private weak var contentTextView: TextView! {
        didSet {
            contentTextView.delegate = self
        }
    }
    @IBOutlet private weak var contentCountLabel: UILabel!
        
    @IBOutlet private weak var ratingButton1: UIButton!
    @IBOutlet private weak var ratingButton2: UIButton!
    @IBOutlet private weak var ratingButton3: UIButton!
    @IBOutlet private weak var ratingButton4: UIButton!
    @IBOutlet private weak var ratingButton5: UIButton!
    
    @IBOutlet private weak var linkTextField: TextField! {
        didSet {
            linkTextField.delegate = self
        }
    }
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    // @IBAction
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        backToHome()
    }
    
    @IBAction private func saveButtonTapped(_ sender: Any) {
        throttler.throttle {
            self.presenter.saveButtonTapped()
        }
    }
    
    @IBAction private func titleTextFieldEditingChanged(_ sender: Any) {
        presenter.titleTextFieldEditingChanged(titleTextField.text)
    }
    
    @IBAction private func linkTextFieldEditingChanged(_ sender: Any) {
        presenter.linkTextFieldEditingChanged(linkTextField.text)
    }
    
    init(navigator: Navigator,
         presenter: WriteReviewPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        self.imageDataSource = WriteImageDataSource(presenter: self.presenter)
        super.init(nibName: WriteReviewViewController.className, bundle: Bundle(for: WriteReviewViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        unregisterNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotifications()
        presenter.view = self
        presenter.viewDidLoad()
        
        registeRatingButtonAction()
        
        imageDataSource.configure(with: imageCollectionView)
    }
    
}

// MARK: - UI Logic
extension WriteReviewViewController {
    func updateProgramInfo(for category: Category, with title: String, and subTitle: String) {
        categoryImageView.image = category.roundImage
        programTitleLabel.text = title
        programSubTitleLabel.text = subTitle
    }
    
    func updateTestField(for title: String, with content: String, and link: String?) {
        titleTextField.text = title
        contentTextView.text = content
        linkTextField.text = link
    }
    
    func updateTitleCountLabelText(with count: String) {
        titleCountLabel.text = count
    }
    
    func updateContentCountLabelText(with count: String) {
        contentCountLabel.text = count
    }
    
    func updateRating(for rating: Int) {
        ratingButton1.isSelected = rating > 0
        ratingButton2.isSelected = rating > 1
        ratingButton3.isSelected = rating > 2
        ratingButton4.isSelected = rating > 3
        ratingButton5.isSelected = rating > 4
    }
     
    func showSelectImageSheet() {
        let actionSheet = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.openPhotoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func reloadImages() {
        DispatchQueue.main.async {
            self.imageCollectionView.reloadData()
        }
    }
    
    // 노티피케이션 등록
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 노티피케이션 등록 해제
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let keyboardInfo = UIKeyboardInfo(notification: notification) else {
            return
        }
        view.layoutIfNeeded()
        scrollViewBottomConstraint.constant = keyboardInfo.frame.size.height
        UIView.animate(withDuration: keyboardInfo.animationDuration,
                       delay: 0,
                       options: keyboardInfo.animationCurve,
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        guard let keyboardInfo = UIKeyboardInfo(notification: notification) else {
            return
        }
        view.layoutIfNeeded()
        scrollViewBottomConstraint.constant = 10
        UIView.animate(withDuration: keyboardInfo.animationDuration,
                       delay: 0,
                       options: keyboardInfo.animationCurve,
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }
    
    private func registeRatingButtonAction() {
        ratingButton1.addTarget(self, action: #selector(ratingButtonTapped(_:)), for: .touchUpInside)
        ratingButton2.addTarget(self, action: #selector(ratingButtonTapped(_:)), for: .touchUpInside)
        ratingButton3.addTarget(self, action: #selector(ratingButtonTapped(_:)), for: .touchUpInside)
        ratingButton4.addTarget(self, action: #selector(ratingButtonTapped(_:)), for: .touchUpInside)
        ratingButton5.addTarget(self, action: #selector(ratingButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc
    private func ratingButtonTapped(_ sender: UIButton) {
        presenter.ratingButtonTapped(at: sender.tag)
    }
}

// MARK: - Navigation
extension WriteReviewViewController {
    func backToHome() {
        navigator?.pop(sender: self, popType: .popToRoot, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension WriteReviewViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isTitle = textField == titleTextField
        return presenter.textField(textField.text, shouldChangeCharactersIn: range, replacementString: string, isTitle: isTitle)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let isTitle = textField == titleTextField
        presenter.textFieldDidBeginEditing(textField.text, isTitle: isTitle)
    }
}

// MARK: - UITextViewDelegate
extension WriteReviewViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        presenter.textViewDidChange(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return presenter.textView(textView.text, shouldChangeCharactersIn: range, replacementString: text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        presenter.textViewDidBeginEditing(textView.text)
    }
}

// MARK: - PHPickerViewControllerDelegate, UIImagePickerControllerDelegate
extension WriteReviewViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openCamera() {
         if UIImagePickerController.isSourceTypeAvailable(.camera) {
             let imagePicker = UIImagePickerController()
             imagePicker.delegate = self
             imagePicker.sourceType = .camera
             imagePicker.allowsEditing = false
             self.present(imagePicker, animated: true, completion: nil)
         } else {
             let alert = UIAlertController(title: "Camera not available", message: "This device has no camera", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
    }
    
    func openPhotoLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = presenter.numberOfImagesSelectLimit // 최대 5개의 이미지를 선택할 수 있도록 설정
        configuration.filter = .images // 이미지만 선택 가능
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        let group = DispatchGroup()
        
        for result in results {
            group.enter()
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadDataRepresentation(forTypeIdentifier: "public.jpeg") { [weak self] data, error in
                    defer { group.leave() }
                    if let data = data {
                        let sizeInMB = Double(data.count) / (1024.0 * 1024.0)
                        Log.debug("Image size in MB: \(sizeInMB)")
                        
                        if sizeInMB <= 10, let image = UIImage(data: data) {
                            self?.presenter.selectImages([image])
                        } else {
                            self?.showToastMessage("10메가 이하의 이미지만 첨부 가능해요.")
                        }
                    } else if let error = error {
                        Log.error("Error loading image data: \(error.localizedDescription)")
                    }
                }
            } else {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
//            self.collectionView.reloadData()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            presenter.selectImages([selectedImage])
//            collectionView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
