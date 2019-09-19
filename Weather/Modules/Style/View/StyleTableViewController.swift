//
//  StyleTableViewController.swift
//  Weather
//
//  Created by Blind Joe Death on 14/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import UIKit

protocol StyleViewProtocol: class {
    func setStyle(style: AppStyle)
    func setItems(items: [AppStyle])
}

class StyleTableViewController: UITableViewController {
    
    var items: [AppStyle]!
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
        //print("Deinited style table view")
    }
}

extension StyleTableViewController: StyleViewProtocol{
    func setItems(items: [AppStyle]) {
        self.items = items
    }
    
    func setStyle(style: AppStyle){
        tableView.backgroundColor = style.color
        tableView.reloadData()
    }
}
