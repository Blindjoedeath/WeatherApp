//
//  StyleTableViewController.swift
//  Weather
//
//  Created by Blind Joe Death on 14/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import UIKit

protocol StyleTableViewControllerDelegate{
    func styleChanged()
}

class StyleTableViewController: UITableViewController {

    var delegate : StyleTableViewControllerDelegate?
    
    var seasons = ["winter", "spring", "summer", "autumn"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
    }
    
    private var style: AppStyle!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appStyles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let styleName = seasons[indexPath.row]
        cell.textLabel?.text = appStyles[styleName]!.description
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func setStyle(){
        style = AppStyleController.currentStyle
        tableView.backgroundColor = style.color
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let styleName = seasons[indexPath.row]
        AppStyleController.changeStyle(by: styleName)
        setStyle()
        delegate?.styleChanged()
    }
}
