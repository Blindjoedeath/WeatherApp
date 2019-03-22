//
//  StyleTableViewController.swift
//  Weather
//
//  Created by Blind Joe Death on 14/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import UIKit

class StyleTableViewController: UITableViewController {
    
    var items: [AppStyleModel]!
    var presenter: StylePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.configureView()
    }
    
    @IBAction func closeButtonAction(){
        presenter.close()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = items{
            return items.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = items[indexPath.row].description
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let styleName = items[indexPath.row].name
        presenter.styleChanged(name: styleName)
    }
    
    deinit {
        print("Deinited style table view")
    }
}

extension StyleTableViewController: StyleViewProtocol{
    func setItems(items: [AppStyleModel]) {
        self.items = items
    }
    
    func setStyle(style: AppStyleModel){
        let color = UIColor(red: CGFloat(style.color.r),
                            green: CGFloat(style.color.g),
                            blue: CGFloat(style.color.b),
                            alpha: 1)
        tableView.backgroundColor = color
        tableView.reloadData()
    }
}
