//
//  GroupViewController.swift
//  comfi
//
//  Created by Brian Li on 10/14/18.
//

import UIKit

class GroupViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureTableView()
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CompetitorTableViewCell", bundle: nil), forCellReuseIdentifier: "CompetitorTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
}

extension GroupViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("gonna add \(GV.friends.count)")
        return GV.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompetitorTableViewCell", for: indexPath) as! CompetitorTableViewCell
        
        cell.nameLabel.text = GV.friends[indexPath.row].first_name
        
        cell.valueLabel.text = "\(20)"
        
        
        if let url = GV.friends[indexPath.row].profileURL {
            let request = URLRequest(url: URL(string: url)!)
            cell.webView.load(request)

        }

        return cell
    }
}
