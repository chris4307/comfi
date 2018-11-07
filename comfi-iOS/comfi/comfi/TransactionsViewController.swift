//
//  TransactionsViewController.swift
//  comfi
//
//  Created by Brian Li on 11/7/18.
//

import UIKit

class TransactionsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureTableView()
    }
    

    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "TransactionEntryCell", bundle: nil), forCellReuseIdentifier: "TransactionEntryCell")
    }

}

extension TransactionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GV.me.transactions.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionEntryCell", for: indexPath) as! TransactionEntryCell
        
        cell.name.text = GV.me.transactions[indexPath.row].name
        cell.date.text = GV.me.transactions[indexPath.row].date
        cell.amount.text = "\(GV.me.transactions[indexPath.row].amount!)"
        
        //let amountFloat = Float(cell.amount)
        let numberFormatter = NumberFormatter()
        let number = numberFormatter.number(from: cell.amount.text!)
        let amountFloat = number?.floatValue
        
        if ((amountFloat?.isLess(than: 0))!){
            cell.amount.textColor = .red
        } else {
            let darkGreen = UIColor(rgb: 0x216C2A)
            cell.amount.textColor = darkGreen
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
