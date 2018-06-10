//
//  ViewController.swift
//  SwiftySearchDemo
//
//  Created by Vincent Lin on 2018/6/10.
//  Copyright © 2018 Vincent Lin. All rights reserved.
//

import UIKit
import SwiftySearch

class ViewController: UIViewController {
    
    let tableView = UITableView()
    
    let titles: [String] = ["Musical genres", "Marvel heroes", "Singers"]
    var currentIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.register(DemoCell.self, forCellReuseIdentifier: DemoCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func check(_ indexPath: IndexPath) -> Bool {
        if titles.count <= indexPath.row {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !check(indexPath) { return UITableViewCell() }
        
        guard let cell = tableView.dequeueCell(reuseIdentifier: DemoCell.identifier, for: indexPath) as? DemoCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = titles[indexPath.row]
        
        let images = [#imageLiteral(resourceName: "musical"), #imageLiteral(resourceName: "marvel"), #imageLiteral(resourceName: "jay")]
        
        cell.customImageView.image = images[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !check(indexPath) { return }
        
        currentIndex = indexPath.row
        let currentTitle = titles[indexPath.row]
        
        let search: SwiftySearchController = {
            let _search = SwiftySearchController().configure {
                $0.receiveTitle = currentTitle
                $0.cancelTextColor = .blue
                $0.navigationTitleColor = .green
                $0.displayStatusBar = true
            }
            return _search
        }()
        
        var hotSearchs: [String] = []
        
        switch indexPath.row {
        case 0:
            search.displayStatusBar = false
            search.navigationTitleColor = .white
            hotSearchs = ["Hip hop", "Pop Music", "Rock", "Blues", "Funk"]
        case 1:
            search.cancelTextColor = .white
            search.searchBarPlaceholder = "Avengers"
            hotSearchs = ["Black Widow", "Iron Man", "Captain America", "Thor", "Hulk", "Black Panther", "Hawkeye"]
        default:
            search.receiveSearchText = "Eminem"
            search.navigationTitleColor = .black
            search.cancelTextColor = .black
            hotSearchs = ["Eminem", "Macklemore", "Post Malone", "Jay Chou", "Sia", "Taylor Swift", "Kendrick Lamar"]
        }
        search.receiveHotSearchs = hotSearchs
        search.delegate = self
        let navi = UINavigationController(rootViewController: search)
        self.present(navi, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

extension ViewController: SwiftySearchControllerDelegate {
    
    /// Set recommendation
    func searchBarTextDidChange(_ searchViewController: SwiftySearchController, searchBar: UISearchBar, searchText: String) {
        var recommendations: [String] = []
        switch currentIndex {
        case 0:
            recommendations = ["Indie Pop", "Jazz", "Latin", "Opera", "Vocal", "Rap"]
        case 1:
            recommendations = ["Loki", "Ronan" ,"Red Skull" ,"Ultron", "Dr.Doom", "Mystique", "Black Cat"]
        case 2:
            recommendations = ["Not Afraid", "Thrift Shop", "Congratulations", "不愛就拉倒", "Genius", "Look What You Made Me Do", "HUMBLE."]
        default:
            break;
        }
        searchViewController.receiveRecommendationTextArray = recommendations
    }
    
    func didSelectedCleanButton(_ searchViewController: SwiftySearchController, cleanButton: UIButton) {
        print("Did Clean Search History")
    }
    
    func didSelectedSearchRecord(_ searchViewController: SwiftySearchController, index: Int, searchRecordText: String, searchText: String) {
        print("didSelectedSearchRecord: \(searchRecordText), index of search record: \(index)")
        searchViewController.dismiss(animated: false, completion: nil)
    }
}


class DemoCell: UITableViewCell {
    
    static let identifier = "DemoCell"
    
    let customImageView: UIImageView = {
       let _imageView = UIImageView()
        _imageView.isHidden = true
        return _imageView
    }()
    
    let titleLabel: UILabel = {
       let _titleLabel = UILabel()
        _titleLabel.isHidden = true
        _titleLabel.backgroundColor = .clear
        _titleLabel.textColor = .white
        _titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        return _titleLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        addSubview(customImageView)
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        customImageView.frame = bounds
        titleLabel.frame = CGRect(x: 15,
                                  y: 30,
                                  width: frame.width - 30,
                                  height: 35)
        
        customImageView.isHidden = false
        titleLabel.isHidden = false
    }
    
    
    
    
    
}


























