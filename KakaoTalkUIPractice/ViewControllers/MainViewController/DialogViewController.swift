//
//  DialogViewController.swift
//  KakaoTalkUIPractice
//
//  Created by BEYun on 2023/03/21.
//

import UIKit
import PhotosUI
import Then

class DialogViewController: UIViewController {
    @IBOutlet weak var mainWrapperView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomInputView: UIView!
    @IBOutlet weak var dialogTableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var hashTagButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    
    public var dialogViewModel: DialogViewModel?
    public var dataSourceProvider: DialogDataSourceProtocol?
    lazy var opponentID = dialogViewModel?.opponentID
    
    var searchBarButton: UIBarButtonItem?
    var cancelBarButton: UIBarButtonItem?
    var checkIndexPathBarButton: UIBarButtonItem?
    
    var searchBar = UISearchBar().then {
        $0.placeholder = "메세지 입력"
        $0.showsCancelButton = false
        $0.becomeFirstResponder()
        
    }
    
    var picker: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        
        return picker
    }()
    
    var filteredIndexPaths: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        // Set Up Layout
        setUpBottomInputView()
        setUpTextView()
        
        // Set Up NavigationBar Layout
        setUpNavigationBarTitle()
        setUptBarButtonItems()
        
        // Register Cell
        registerCustomCell()
        
        // Set Keyboard Animation
        addNotification()
        setUpGestureRecognizer(willTapView: dialogTableView)
        
        // Delegates
        textView.delegate = self
        searchBar.delegate = self
        picker.delegate = self
        dialogTableView.delegate = dataSourceProvider
        dialogTableView.dataSource = dataSourceProvider
        dialogViewModel?.delegate = self
        
        // Initial Scroll Location
        scrollToBottomRow()
    }
    
    
    func registerCustomCell() {
        dialogTableView.register(UINib(nibName: "MyDialogTableViewCell", bundle: nil), forCellReuseIdentifier: "MyDialogTableViewCell")
        dialogTableView.register(UINib(nibName: "OpponentDialogTableViewCell", bundle: nil), forCellReuseIdentifier: "OpponentDialogTableViewCell")
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardToggleAnimate(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardToggleAnimate(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setUpGestureRecognizer(willTapView: UIView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAnyView))
        tapGestureRecognizer.cancelsTouchesInView = false
        willTapView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func scrollToBottomRow() {
        guard let dialogCount = dataSourceProvider?.dialogCount else { return }
        if dialogCount > 0 {
            let endIndex = IndexPath(row: dialogCount - 1, section: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) {
                self.dialogTableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
            }
        }
    }
    
}

// MARK: Layout SetUp Method
extension DialogViewController {
    func initBottomInputView() {
        textView.text = ""
        toggleSubmitButton()
        scrollToBottomRow()
        setUpTextView()
        bottomViewHeightConstraint.constant = CGFloat(Constraint.bottomViewInitHeight)
    }
    
    func setUpBottomInputView() {
        bottomInputView.layer.cornerRadius = textView.bounds.height / 2
        bottomInputView.layer.borderWidth = 1
        bottomInputView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setUpTextView() {
        textView.textContainerInset = TextViewInset.initial
    }
    
    func setUpNavigationBarTitle() {
        guard let name = dataSourceProvider?.opponentName else { return}
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.text = name
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
    }
    
    func setUpSearchBar() {
        navigationItem.titleView = searchBar
    }
    
    func setUptBarButtonItems() {
        checkIndexPathBarButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(leftBarBtnTapped))
        searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(rightBarBtnTapped))
        cancelBarButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(rightBarBtnTapped))
        checkIndexPathBarButton?.tintColor = .lightGray
        searchBarButton?.tintColor = .lightGray
        cancelBarButton?.tintColor = .lightGray
        
        self.navigationItem.setRightBarButton(searchBarButton, animated: true)
    }
    
    
    
    //MARK: 보완할 곳
    func changeTextViewHeight(_ textView: UITextView) {
        let currentLines = textView.numberOfLine()
        let maxHeightConstraint = CGFloat(Constraint.bottomViewHeightPerRow * 5 + Constraint.textViewTopInset)
        let dynamicHeight = CGFloat(Constraint.bottomViewHeightPerRow * currentLines + Constraint.textViewTopInset)
        
        switch currentLines {
        case 1:
            bottomViewHeightConstraint.constant = CGFloat(Constraint.bottomViewInitHeight)
            textView.textContainerInset = TextViewInset.initial
        case 2...4:
            bottomViewHeightConstraint.constant = dynamicHeight
            
            textView.textContainerInset = TextViewInset.increasing
        case 5 where bottomViewHeightConstraint.constant != maxHeightConstraint:
            bottomViewHeightConstraint.constant = dynamicHeight
            
            textView.textContainerInset = TextViewInset.maxHeight
        default :
            textView.textContainerInset = TextViewInset.maxHeight
        }
        
        scrollToBottomRow()
    }
    
    func toggleSubmitButton() {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            hashTagButton.isHidden = false
            submitButton.isHidden = true
        } else {
            hashTagButton.isHidden = true
            submitButton.isHidden = false
        }
    }
    
    func barbuttonAnimation(hide: Bool) {
        if hide {
            UIView.animate(withDuration: 0.05, delay: 0, animations: { [weak self] in
                guard let self = self else { return }
                self.bottomView.transform = CGAffineTransform(translationX: 0, y: self.bottomView.frame.height)
            })
        } else {
            UIView.animate(withDuration: 0.05, delay: 0, animations: { [weak self] in
                guard let self = self else { return }
                self.bottomView.transform = .identity
            })
        }
    }
}

// MARK: IBActions
extension DialogViewController {
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        guard let text = textView.text else { return }
        dialogViewModel?.addTextDialog(text)
        dialogTableView.reloadData()
        scrollToBottomRow()
        initBottomInputView()
    }
    
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        self.present(picker, animated: true, completion: nil)
    }
    
}

// MARK: objc Method
extension DialogViewController {
    @objc
    private func keyboardToggleAnimate(_ sender: Notification) {
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let bottomSafeAreaInset = view.safeAreaInsets.bottom
        
        switch sender.name {
        case UIResponder.keyboardWillShowNotification:
            mainWrapperView.transform = CGAffineTransform(translationX: 0, y: -(keyboardHeight - bottomSafeAreaInset))
            dialogTableView.contentInset.top = keyboardHeight - bottomSafeAreaInset
        case UIResponder.keyboardWillHideNotification:
            mainWrapperView.transform = .identity
            dialogTableView.contentInset.top = .zero
            
        default:
            break
        }
        
        self.view.layoutIfNeeded()
    }
    
    @objc
    private func didTapAnyView() {
        if textView.isFirstResponder {
            textView.resignFirstResponder()
        }
    }
    
    @objc
    private func rightBarBtnTapped() {
        let barButton = self.navigationItem.rightBarButtonItem
        switch barButton {
        case searchBarButton:
            self.navigationItem.setRightBarButton(cancelBarButton, animated: true)
            self.navigationItem.setLeftBarButton(checkIndexPathBarButton, animated: true)
            barbuttonAnimation(hide: true)
            setUpSearchBar()
        case cancelBarButton:
            self.navigationItem.setRightBarButton(searchBarButton, animated: true)
            self.navigationItem.leftBarButtonItem = nil
            setUpNavigationBarTitle()
            barbuttonAnimation(hide: false)
        default:
            break
        }
    }
    
    @objc
    private func leftBarBtnTapped() {
        print(filteredIndexPaths)
    }
    
}

extension DialogViewController: UpdateTableViewDelegate {
    func updateTableView() {
        self.dialogTableView.reloadData()
        self.scrollToBottomRow()
    }
}
