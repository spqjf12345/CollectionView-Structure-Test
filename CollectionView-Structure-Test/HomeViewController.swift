//
//  HomeViewController.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/17.
//

import UIKit

class HomeViewController: UITableViewController {
    let solutions = ["pageViewController", "collectionView"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return solutions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var configuration = cell.defaultContentConfiguration()
        configuration.text = solutions[indexPath.row]
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let viewControlelr = ViewController(nibName: "ViewController", bundle: nil)
            navigationController?.pushViewController(viewControlelr, animated: true)
        } else if indexPath.row == 1 {
            let viewControlelr = CollectionViewController()
            navigationController?.pushViewController(viewControlelr, animated: true)
        }
    }
}


