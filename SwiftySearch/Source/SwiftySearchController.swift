//
//  DynamicSearchController.swift
//  Job1111
//
//  Created by Vincent Lin on 13/04/2018.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import Foundation
import UIKit

extension String: HotSearchConvertible {
    public var title: String {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
}

@objc public protocol SwiftySearchControllerDelegate: NSObjectProtocol {
    /**
     did selected each search recommendation call the follow method
     - parameter searchViewController        :           view owner viewController
     - parameter recommendationText          :           recommendate text
     - parameter searchText                  :           current searchBar's text
     */
    @objc optional func didSelectedRecommendation(_ searchViewController: SwiftySearchController,
                                   index: Int,
                                   recommendationText: String,
                                   searchText: String)
    /**
     did selected each hot search call the follow method
     - parameter searchViewController        :           view owner viewController
     - parameter hotSearch                   :           hot search model
     - parameter searchText                  :           current searchBar's text
     */
    @objc optional func didSelectedHotSearch(_ searchViewController: SwiftySearchController,
                              index: Int,
                              hotSearch: String,
                              searchText: String)
    /**
     did selected each search record call the follow method
     - parameter searchViewController        :           view owner viewController
     - parameter searchRecordText            :           search record text
     - parameter searchText                  :           current searchBar's text
     */
    @objc optional func didSelectedSearchRecord(_ searchViewController: SwiftySearchController,
                                 index: Int,
                                 searchRecordText: String,
                                 searchText: String)
    /**
     searchBar text did changed call the follow method
     - parameter searchViewController        :           view owner viewController
     - parameter searchBar                   :           current searchBar
     - parameter searchText                  :           current searchBar's text
     */
    @objc optional func searchBarTextDidChange(_ searchViewController: SwiftySearchController,
                                searchBar: UISearchBar,
                                searchText: String
    )
    
    /**
     call the follow method when searchBar did end editing
     - parameter searchViewController        :           view owner viewController
     - parameter searchBar                   :           current searchBar
     */
    @objc optional func searchBarTextDidEndEditing(_ searchViewController: SwiftySearchController,
                                    searchBar: UISearchBar)
    
    
    /**
     call the follow method when searchBar did tap clean button
     - parameter searchViewController        :           view owner viewController
     - parameter searchBar                   :           current searchBar
     - parameter cleanButton                 :           The button for clean search history
     */
    @objc optional func didSelectedCleanButton(_ searchViewController: SwiftySearchController,
                                                 cleanButton: UIButton)
}

/**
 - multiPurpose:       SearchHistory + HotSearch
 - showRecommendation: Show Search Recommendation
 */
enum SwiftySearchDynamicMode {
    case multiPurpose, showRecommendation
}


/**
 建立兩個tableView, 一個用來顯示熱門關鍵字, 另一個來顯示搜尋紀錄
 搜尋紀錄採取model的方式導入, 要特別紀錄 活動點擊不列入搜尋紀錄裡面
 交換模式時, delegate, dataSource要清掉 然後交換
 接收改變值 'navigation title', 'search records', 'hot search list', 'Search Bar placeholder', 'Search Bar TextColor', 'Search Bar Text'
 */
open class SwiftySearchController: UIViewController {
    
    public typealias ConfigureCompletion = ((SwiftySearchController) -> Void)
    
    //MARK: - Properties
    
    /**
     預設Title '預設值Search'
     Navigation default title, title only show in iOS11
     */
    open var receiveTitle: String = "Search".localized
    
    /// default searchBar text, default = ""
    open var receiveSearchText: String = ""
    
    /**
     預設熱門關鍵字, data type are [SearchHotSearchModel], '預設值空陣列'
     */
    open var receiveHotSearchs: [HotSearchConvertible] = []
    
    /**
     SearchBar的placeholder, '預設值EnterKeyword'
     SearchBar placeholder text, sets placeholder text initially *EnterKeyword*
     */
    open var searchBarPlaceholder: String = "EnterKeyword".localized
    
    /// The SwitySearchCell cleanButton text.
    open var cancelButtonText: String = "Close".localized
    
    /// The SwitySearchCell cleanButton text color.
    open var cancelTextColor: UIColor = .white
    
    /// The navigationBar title color, title only show in iOS11
    open var navigationTitleColor: UIColor = .white
    
    /**
     Search Bar的文字顏色, '預設UIColor.Gray.customTextColor'
     */
    open var searchBarTextColor: UIColor = UIColor.darkGray
    
    /**
     搜尋紀錄最大比數, default = 10
     */
    open var maxOfSearchRecords: Int = 10
    
    open var displayStatusBar: Bool = true
    
    
    /**
     推薦關鍵字, data type are [String], '預設值空字串陣列'
     */
    open var receiveRecommendationTextArray: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.recommendationTableView.reloadData()
            }
        }
    }
    
    /**
     預設搜尋紀錄, data type are [String], '預設值空字串陣列'
     */
    open fileprivate(set) var searchRecords: [String] = []

    
    /**
     SearchBar's textField currect text
     */
    fileprivate var searchText: String = ""
    
    /**
     畫面呈現模式, 都是畫面上自己判斷
     預設 'MultiPurpose'
     */
    fileprivate var mode: SwiftySearchDynamicMode = .multiPurpose
    
    
    /**
     MultiPurpose時, 固定item數量 = 2
     */
    fileprivate let multiPurposeNumberOfItem: Int = 2
    
    /**
     Search Record Cell Tag No
     */
    fileprivate let searchRecordCellTag: Int = 38383
    
    /**
     Hot Search Cell Tag No
     */
    fileprivate let hotSearchCellTag: Int = 78787
    
    
    /**
     Search Record Cell Height
     */
    fileprivate var searchRecordCellHeight: CGFloat = 0.0
    
    /**
     Hot Search Cell Height
     */
    fileprivate var hotSearchCellHeight: CGFloat = 0.0
    
    /**
     在`手指`移動時 關閉鍵盤, 若使用這功能則為true
     */
    open private(set) var dismissKeyboardOnDragEnable: Bool = true;

    
    /**
     取得獲得代理, 完成DynamicSearchControllerDelegate
     */
    public weak var delegate: SwiftySearchControllerDelegate?
    
    //MARK: - UI Declaration
    /**
     The tableView use to show *SearchHistory* and *HotSearch*.
     */
    fileprivate let multiPurposeTableView: UITableView = {
        let _multiPurposeTableView = UITableView()
        _multiPurposeTableView.isHidden = true
        _multiPurposeTableView.separatorStyle = .none         // 清除分隔線
        _multiPurposeTableView.tableFooterView = UIView()     // 清空footer, 怕seperator殘留
        return _multiPurposeTableView
    }()
    
    /**
     The tableView use to show search recommendations.
     */
    fileprivate let recommendationTableView: UITableView = {
        let _recommendationTableView = UITableView()
        _recommendationTableView.isHidden = true
        _recommendationTableView.tableFooterView = UIView()     // 清空footer, 怕seperator殘留
        return _recommendationTableView
    }()
    

    fileprivate let searchController: WithoutCancelSearchController = {
        let _searchController = WithoutCancelSearchController(searchResultsController: nil)
        _searchController.searchBar.backgroundColor = .clear
        _searchController.searchBar.tintColor = UIColor.Blue.mainBlue
        //        _searchController.searchBar.tintColor = .white    // 改變Cancel字樣的顏色
        
        _searchController.dimsBackgroundDuringPresentation = false
        return _searchController
    }()
    
    
    //MARK: ViewDid
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigation()                   // navigation基礎設定
        setupSearchController()             // SearchBar基礎設定
        setupTableView()                    // 兩個tableView基礎設定
        configureSearchRecords()            // 若無資料, 則設定 searchRecordCellHeight 為 0
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - ScrollView
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let topViewController = UIApplication.topViewController() {
            if topViewController is UISearchController && mode == .showRecommendation && dismissKeyboardOnDragEnable {
                searchController.searchBar.resignFirstResponder()
            }
        }
    }
    
    //MARK: - Touches
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyboardOnDragEnable = true   // 移動中打開
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyboardOnDragEnable = false  // 取消移動 則關閉, 避免reloadData會呼叫到 scrolViewDidScroll 導致鍵盤縮起來
    }
    
    //MARK: - Setup UI
    
    
    open func configure( _ item: ConfigureCompletion ) -> Self {
        item(self)
        return self
    }
    
    /**
     設定Navigation基礎
     */
    private func setupNavigation() {
        navigationItem.title = receiveTitle
        if let navigation = self.navigationController?.navigationBar {
            #if swift(>=4.0)
            navigation.titleTextAttributes = [NSAttributedStringKey.foregroundColor: self.navigationTitleColor]
            #else
            navigation.titleTextAttributes = [NSFontAttributeName: self.navigationTitleColor]
            #endif
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: self.cancelButtonText, style: .done, target: self, action: #selector(doDismiss))
        navigationItem.rightBarButtonItem?.tintColor = self.cancelTextColor
    }
    
    /**
     Set up separately by iOS11 or not.
     */
    private func setupSearchController() {
        
        // 1.
        searchController.searchBar.placeholder = self.searchBarPlaceholder
        searchController.searchBar.text = self.receiveSearchText
        searchController.searchBar.tintColor = SwiftySearchCustom.cursorColor
        #if swift(>=4.0)
        searchController.searchBar.subviews[0].subviews.compactMap(){ $0 as? UITextField }.first?.tintColor = SwiftySearchCustom.cursorColor
        #else
        searchController.searchBar.subviews[0].subviews.flatMap(){ $0 as? UITextField }.first?.tintColor = SwiftySearchCustom.cursorColor
        #endif
        searchController.hidesNavigationBarDuringPresentation = false ;
        searchText = self.receiveSearchText
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            let colors: [UIColor] = [UIColor.Blue.waterBlue, UIColor.Blue.mainBlue]
            if let naviBar = navigationController?.navigationBar {
                if let gradientImage = CAGradientLayer(frame: naviBar.frame, colors: colors).creatGradientImage() {
                    naviBar.barTintColor = UIColor(patternImage: gradientImage)
                }
            }
            
            if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                textField.textColor = self.searchBarTextColor
                if let backgroundview = textField.subviews.first {
                    backgroundview.backgroundColor = UIColor.white
                    backgroundview.layer.cornerRadius = 10;
                    backgroundview.clipsToBounds = true;
                    
                }
            }
            
        } else {
            navigationItem.titleView = searchController.searchBar
            if let searchBarFirstSubView = searchController.searchBar.subviews.first {
                for subView in searchBarFirstSubView.subviews {
                    if subView is UITextField {
                        if let textField = subView as? UITextField {
                            textField.tintColor = SwiftySearchCustom.cursorColor
                            break ;
                        }
                    }
                }
            }
            if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                textField.tintColor = SwiftySearchCustom.cursorColor
            }
            
        }
        searchController.searchBar.delegate = self
    }
    
    private func setupTableView() {
        
        multiPurposeTableView.delegate = self
        multiPurposeTableView.dataSource = self
        view.addSubview(multiPurposeTableView)
        view.addSubview(recommendationTableView)
        

        multiPurposeTableView.register(SwiftySearchCell.self)
        recommendationTableView.register(StyleHighlightCell.self)
        
        if #available(iOS 11.0, *) {
            multiPurposeTableView.anchorWithSameConstantToView(view.safeAreaLayoutGuide.topAnchor,
                                                               left: view.leftAnchor,
                                                               bottom: view.bottomAnchor,
                                                               right: view.rightAnchor,
                                                               sameValue: 0.0)
            recommendationTableView.anchorWithSameConstantToView(view.safeAreaLayoutGuide.topAnchor,
                                                                 left: view.leftAnchor,
                                                                 bottom: view.bottomAnchor,
                                                                 right: view.rightAnchor,
                                                                 sameValue: 0.0)
        } else {
            multiPurposeTableView.anchorWithSameConstantToView(topLayoutGuide.bottomAnchor,
                                                               left: view.leftAnchor,
                                                               bottom: view.bottomAnchor,
                                                               right: view.rightAnchor,
                                                               sameValue: 0.0)
            recommendationTableView.anchorWithSameConstantToView(topLayoutGuide.bottomAnchor,
                                                                 left: view.leftAnchor,
                                                                 bottom: view.bottomAnchor,
                                                                 right: view.rightAnchor,
                                                                 sameValue: 0.0)
        }

        
        multiPurposeTableView.isHidden = false
    }
    
    open override var prefersStatusBarHidden: Bool {
        return !displayStatusBar
    }
    
    /**
     組建 searchRecords,
     若無資料, 則設定 searchRecordCellHeight 為 0
     */
    private func configureSearchRecords() {
        if let savedRecords = getSearchRecords() {
            searchRecords = savedRecords
        } else {
            if delegate != nil {
                searchRecordCellHeight = 0.0
            }
        }
    }
    
    
    //MARK: - Actions
    
    /**
     關閉視窗
     */
    @objc fileprivate func doDismiss() {
        view.endEditing(true) ; // 先關鍵盤
        if mode == .showRecommendation {
            toggleMode(.multiPurpose)
            toggleDelegateAndDataSource(.multiPurpose)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    /**
     儲存搜尋紀錄
     
     - parameter searchText          :            搜尋文字
     */
    fileprivate func saveSearchRecord(_ searchText: String) {
        let trimSearchText: String = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let searchHistory = UserDefaults.Key.searchHistory.storedValue as? [String] {
            var copySearchHistory = searchHistory
            
            for (index,record) in copySearchHistory.enumerated() {
                if record == trimSearchText {
                    copySearchHistory.remove(at: index)
                }
            }
            if copySearchHistory.count > maxOfSearchRecords {
                copySearchHistory.removeLast()
            }
            copySearchHistory.append(trimSearchText)
            UserDefaults.Key.searchHistory.store(copySearchHistory)
        } else {
            UserDefaults.Key.searchHistory.store([searchText])
        }
        configureSearchRecords()
        multiPurposeTableView.reloadData()
    }
    
    /**
     取得存在本機端的搜尋紀錄列表
     - returns:                  [String]? , 有可能沒有值
     */
    fileprivate func getSearchRecords() -> [String]? {
        if let savedRecords = UserDefaults.Key.searchHistory.storedValue as? [String] {
            return savedRecords
        } else {
            return nil
        }
    }
    
    
    /**
     Clean all data about search record, 'UserDefault data', 'searchRecords', 'related tableView cell subViews'
     reset searchRecordCellHeight to zero
     */
    fileprivate func removeSearchRecordsAndCellSubViews(_ cell: SwiftySearchCell, cleanButton: UIButton) {
        // 清除搜尋紀錄的所有東西
        UserDefaults.Key.searchHistory.clean()
        searchRecords.removeAll()
        _ = cell.subviews.map({$0.removeFromSuperview()}) // 不能和下面 順序顛倒, 會讓cell高度無法更新
        searchRecordCellHeight = 0.0                     // <<<<<<<
        self.delegate?.didSelectedCleanButton?(self, cleanButton: cleanButton)
    }
    
}
//MARK: - Implement UITableViewDataSource

extension SwiftySearchController: UITableViewDataSource {
    
    /**
     multiPurpose時, 目前為兩個Cell,
     recommendation時, 則以recommendation的數量為準
     */
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mode == .multiPurpose {
            return multiPurposeNumberOfItem
        } else {
            return receiveRecommendationTextArray.count
        }
    }
    
    /**
     multiPurpose時, 呼叫DynamicCell,
     將相關值 'hotSearch', 'search record' 傳給cell
     
     recommendation時, 則以recommendation的數量為準
     */
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if mode == .multiPurpose {
            return getMultiPurposeModeCell(tableView,cellForRowAt:indexPath)
        } else {
            return getRecommendationModeCell(tableView,cellForRowAt:indexPath)
        }
    }
    
    /**
     獲得 多用途TableView的Cell
     - parameter tableView                :               The current tableView
     - parameter indexPath                :               IndexPath of tableView
     - return                             :               Target cell
     */
    private func getMultiPurposeModeCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assert(mode == .multiPurpose)
        var cell = SwiftySearchCell()
        _ = cell.subviews.map({$0.removeFromSuperview()})
        cell = tableView.dequeue(SwiftySearchCell.self, for: indexPath)
        SwiftySearchCellCustom.backgroundColor = .white
        cell.delegate = self
        if isSearchRecordCell(indexPath) {
            cell.tag = searchRecordCellTag
            cell.isHidden = searchRecords.isEmpty
            SwiftySearchCellCustom.titleText = "SearchRecord".localized
            SwiftySearchCellCustom.cleanButtonTitle = "" ;
            SwiftySearchCellCustom.isHiddenCleanButton = false
            SwiftySearchCellCustom.optionButtonBorderColor = SwiftySearchCustom.searchRecordOptionButtonBorderColor
            SwiftySearchCellCustom.optionButtonTextColor = SwiftySearchCustom.searchRecordOptionButtonTextColor
            cell.receiveOptionData = searchRecords
            
        } else {
            cell.tag = hotSearchCellTag
            cell.isHidden = receiveHotSearchs.isEmpty
            SwiftySearchCellCustom.titleText = "HotSearch".localized
            SwiftySearchCellCustom.isHiddenCleanButton = true
            SwiftySearchCellCustom.optionButtonBorderColor = SwiftySearchCustom.hotSearchOptionButtonBorderColor
            SwiftySearchCellCustom.optionButtonTextColor = SwiftySearchCustom.hotSearchOptionButtonTextColor
            let hotSearchMsgArray = receiveHotSearchs.map({return $0.title})
            cell.receiveOptionData = hotSearchMsgArray
            
        }
        
        return cell
    }
    
    
    /**
     Get the cell which show recommendation text.
     */
    private func getRecommendationModeCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assert(mode != .multiPurpose)
        let cell = tableView.dequeue(StyleHighlightCell.self, for: indexPath)
        assert(indexPath.row < receiveRecommendationTextArray.count, "indexPath.row錯誤")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
        cell.textLabel?.textColor = .darkText
        cell.textLabel?.text = ""
        if indexPath.row < receiveRecommendationTextArray.count {
            let recommendationString = receiveRecommendationTextArray[indexPath.row]
            cell.textLabel?.text = recommendationString
        }
        return cell
    }
    
    
    
    /**
     判斷是否為search record那個cell
     - parameter indexPath          :             indexPath of tableView
     */
    fileprivate func isSearchRecordCell(_ indexPath: IndexPath) -> Bool {
        if indexPath.item == multiPurposeNumberOfItem - 1 {
            return SwiftySearchCustom.swapSearchRecordWithHotSearch
        } else {
            return !SwiftySearchCustom.swapSearchRecordWithHotSearch
        }
    }
    
    /**
     交換模式, 並交換TableView delegate, dataSource
     
     - parameter toMode              :                Target mode
     */
    fileprivate func toggleMode(_ toMode: SwiftySearchDynamicMode) {
        if targeModeEuqalCurrent(toMode) {return}
        if toMode == .multiPurpose {
            mode = .multiPurpose
        } else {
            mode = .showRecommendation
        }
        searchController.hidesNavigationBarDuringPresentation = false ;
    }
    
    
    /**
     According mode to swap delegate and dataSource
     - parameter toMode              :                Target mode
     */
    fileprivate func toggleDelegateAndDataSource(_ toMode: SwiftySearchDynamicMode) {
        
        if toMode == .multiPurpose {
            multiPurposeTableView.delegate = self
            multiPurposeTableView.dataSource = self
            multiPurposeTableView.isHidden = false
            recommendationTableView.delegate = nil
            recommendationTableView.dataSource = nil
            recommendationTableView.isHidden = true
        } else {
            multiPurposeTableView.delegate = nil
            multiPurposeTableView.dataSource = nil
            multiPurposeTableView.isHidden = true
            recommendationTableView.delegate = self
            recommendationTableView.dataSource = self
            recommendationTableView.isHidden = false
        }
    }
    
    /**
     Check the target mode euqal current mode or not
     - returns:                   If equal, return true
     */
    private func targeModeEuqalCurrent(_ targetMode: SwiftySearchDynamicMode) -> Bool {
        return mode == targetMode
    }
    
}
//MARK: - Implement UITableViewDelegate
extension SwiftySearchController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if mode == .multiPurpose {
            return isSearchRecordCell(indexPath)
                ? searchRecordCellHeight
                : hotSearchCellHeight
        } else {
            return 60.0
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mode == .showRecommendation {
            assert(indexPath.row < receiveRecommendationTextArray.count, "indexPath錯誤")
            if delegate != nil {
                if let top = UIApplication.topViewController() {
                    top.dismiss(animated: false, completion: {
                        self.searchController.isActive = false
                        if indexPath.row < self.receiveRecommendationTextArray.count {
                            let recommendationText = self.receiveRecommendationTextArray[indexPath.row]
                            self.delegate?.didSelectedRecommendation?(
                                self,
                                index: indexPath.row,
                                recommendationText: recommendationText,
                                searchText: self.self.searchController.searchBar.text ?? "")
                            self.searchController.searchBar.text = recommendationText
                            self.saveSearchRecord(recommendationText)
                        }
                        self.toggleMode(.multiPurpose)
                        self.toggleDelegateAndDataSource(.multiPurpose)
                    })
                }
            } else {
                // 若無代理
                searchController.isActive = false
            }
        }
    }
}
//MARK: - Implement DynamicSearchCellDelegate
extension SwiftySearchController: SwiftySearchCellDelgate {
    func heightDidUpdated(heightFor cell: SwiftySearchCell, height: CGFloat) {
    }
    
    func didSelectedOption(_ cell: SwiftySearchCell, optionIndex: Int, optionButton: UIButton) {
        if cell.tag == searchRecordCellTag {
            assert(optionIndex < searchRecords.count, "index 錯誤")
//            print("didSelected indexOfSearchRecord: \(searchRecords[optionIndex])")
            if delegate != nil {
                delegate?.didSelectedSearchRecord?(self,
                                                  index: optionIndex,
                                                  searchRecordText: searchRecords[optionIndex],
                                                  searchText: searchText)
            }
        } else {
            assert(optionIndex < receiveHotSearchs.count, "index 錯誤")
//            print("didSelected indexOfHotSearch \(receiveHotSearchs[optionIndex])")
            if delegate != nil {
                delegate?.didSelectedHotSearch?(self,
                                               index: optionIndex,
                                               hotSearch: receiveHotSearchs[optionIndex].title,
                                               searchText: searchText)
            }
        }
    }
    
    @objc internal func didSelectedCleanButton(_ cell: SwiftySearchCell, cleanButton: UIButton) {
        assert(cell.tag != hotSearchCellTag, "hotSearch不該有移除鈕")
        if cell.tag == searchRecordCellTag {
            removeSearchRecordsAndCellSubViews(cell, cleanButton: cleanButton)
            DispatchQueue.main.async {
                self.multiPurposeTableView.reloadData()
            }
        }
    }
    
    
    
    @objc internal func updateToFinalCellHeight(heightFor cell: SwiftySearchCell, height: CGFloat) {
        if cell.tag == searchRecordCellTag {
            if searchRecordCellHeight != height {
                searchRecordCellHeight = height
            }
        } else {
            if hotSearchCellHeight != height {
                hotSearchCellHeight = height
            }
        }
        // 刷新高度
        multiPurposeTableView.beginUpdates()
        multiPurposeTableView.endUpdates()
    }
}
//MARK: - Implement UISearchBarDelegate
extension SwiftySearchController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        toggleMode(.showRecommendation)
        toggleDelegateAndDataSource(.showRecommendation)
        if searchText == "" || searchText.isEmpty {
            return     // 呼叫空字串, 會清空選項
        }
        if delegate != nil {
            delegate!.searchBarTextDidChange?(
                self,
                searchBar: searchBar,
                searchText: searchText)
        }
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        toggleMode(.showRecommendation)
        toggleDelegateAndDataSource(.showRecommendation)
        if searchBar.text ?? "" != "" { // 若本身有值, 一打開就先搜尋
            if delegate != nil {
                delegate?.searchBarTextDidChange?(
                    self,
                    searchBar: searchBar,
                    searchText: searchText)
            }
        }
        searchBar.tintColor = SwiftySearchCustom.cursorColor
        #if swift(>=4.0)
        searchBar.subviews[0].subviews
            .compactMap(){ $0 as? UITextField }
            .first?
            .becomeFirstResponder()
        #else
        searchBar.subviews[0].subviews
        .flatMap(){ $0 as? UITextField }
        .first?
        .becomeFirstResponder()
        #endif
        if let first = searchBar.subviews.first {
            for sub in first.subviews {
                if sub is UITextField {
                    if let textField = sub as? UITextField {
                        textField.tintColor = SwiftySearchCustom.cursorColor
                        textField.becomeFirstResponder()
                    }
                }
            }
        }
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        toggleMode(.multiPurpose)
        toggleDelegateAndDataSource(.multiPurpose)
    }
    
    public func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        saveSearchRecord(searchBar.text ?? "")
        doDismiss()
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if delegate != nil {
            delegate?.searchBarTextDidEndEditing?(self, searchBar: searchBar)
        }
    }
}




