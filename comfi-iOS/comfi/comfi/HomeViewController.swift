//
//  HomeViewController.swift
//  ChrisAndJustinsPages
//
//  Created by Justin Kim on 10/13/18.
//  Copyright © 2018 CJ LLC. All rights reserved.
//

import UIKit
import Charts

class HomeViewController: UIViewController {

    var pieChart = PieChartView()
    
    @IBOutlet var chartView: UIView!
    
    @IBOutlet var YourFinances: UILabel!
    @IBOutlet var TransactionsLabel: UILabel!
    @IBOutlet var CurrentBalance: UILabel!
    
    @IBOutlet var TransactionTable: UITableView!
    //var balance: Float!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let balance = 14.50
        YourFinances.text = "Your Finances"
        CurrentBalance.text = "Current Balance: " + balance.description
        
        configureTableView()
        
        var myUser = User()
        var transA = Transaction()
        transA.amount = 10
        transA.date = "10/10/10"
        transA.name = "chipotle"
        var transB = Transaction()
        transB.amount = 10
        transB.date = "11/11/11"
        transB.name = "mcdonalds"
        var myTransactions = [transA, transB]
        
        myUser.first_name = "justin"
        myUser.last_name = "last_name"
        myUser.fbid = "12313123123213123"
        myUser.current_balance = 112.34
        myUser.transactions = myTransactions
        GV.me = myUser
        
        
        
        configurePieChart()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView() {
        TransactionTable.dataSource = self
        TransactionTable.register(UINib(nibName: "TransactionEntryCell", bundle: nil), forCellReuseIdentifier: "TransactionEntryCell")
        TransactionTable.rowHeight = 72
    }
    
    
    
}

extension HomeViewController:  UITableViewDataSource, UITableViewDelegate {
    
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
        cell.amount.text = "\(GV.me.transactions[indexPath.row].amount)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

extension HomeViewController: ChartViewDelegate {
    
    func configurePieChart() {
        self.setup(pieChartView: pieChart)
        pieChart.frame = self.chartView.bounds
        self.chartView.addSubview(pieChart)
        
        // generate chart data entries
        let track = ["Income", "Expense", "Wallet", "Bank"]
        let money = [650, 456.13, 78.67, 856.52]
        updateChartData(forPieChart: pieChart, labels: track, data: money)
    }
    
    func updateChartData(forPieChart chart: PieChartView, labels: [String], data: [Double])  {
        
        var entries = [PieChartDataEntry]()
        
        if(labels.count == data.count) {
            for (index, label) in labels.enumerated() {
                let entry = PieChartDataEntry()
                entry.y = data[index]
                entry.label = label
                entries.append(entry)
            }
        }
        
        let set = PieChartDataSet( values: entries, label: "Pie Chart")
        // this is custom extension method. Download the code for more details.
        /*
         var colors: [UIColor] = []
         
         for _ in 0..<money.count {
         let red = Double(arc4random_uniform(256))
         let green = Double(arc4random_uniform(256))
         let blue = Double(arc4random_uniform(256))
         let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
         colors.append(color)
         }
         set.colors = colors
         */
        set.colors = ChartColorTemplates.material()
        let data = PieChartData(dataSet: set)
        chart.data = data
        
        
        let d = Description()
        d.text = "iOSCharts.io"
        chart.chartDescription = d
        chart.centerText = "Pie Chart"
        chart.holeRadiusPercent = 0.2
        chart.transparentCircleColor = UIColor.clear
    }
    
    func setup(pieChartView chartView: PieChartView) {
        chartView.noDataText = "no data available"
        chartView.isUserInteractionEnabled = true
        
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        
        chartView.drawCenterTextEnabled = true
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: "Charts\nby Daniel Cohen Gindi")
        centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 13)!,
                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
                                  .foregroundColor : UIColor.gray], range: NSRange(location: 10, length: centerText.length - 10))
        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
                                  .foregroundColor : UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)], range: NSRange(location: centerText.length - 19, length: 19))
        chartView.centerAttributedText = centerText;
        
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        //        chartView.legend = l
    }
}

