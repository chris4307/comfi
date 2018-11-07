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
    
    @IBOutlet var TransactionsLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        /*
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
        */
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTableView()
        
        configurePieChart()
        
        var labels: [String] = []
        var data: [Double] = []
        
        for (key, value) in GV.HomeScreen.pieChartDict {
            labels.append(key as! String)
            data.append(value["amount"] as! Double)
        }
        
        updateChartData(forPieChart: pieChart, labels: labels, data: data)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    
        tableView.register(UINib(nibName: "TransactionEntryCell", bundle: nil), forCellReuseIdentifier: "TransactionEntryCell")
        
        // remove empty cells
        tableView.tableFooterView = UIView()
    }
    
    
    
}

extension HomeViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionEntryCell", for: indexPath) as! TransactionEntryCell
        cell.selectionStyle = .none

        switch indexPath.row {
        case 0:
            cell.name.text = "Current Balance"

            let date = NSDate()
            let calendar = NSCalendar.current
            let day = calendar.component(.day, from: date as Date)
            let month = calendar.component(.month, from: date as Date)
            let year = calendar.component(.year, from: date as Date)
            
            cell.date.text = "as of \(month)/\(day)/\(year)"
            cell.amount.text = "$\(GV.me.current_balance!)"
        case 1:
            cell.name.text = "Predicted Spending"
            cell.date.text = "of next month's income"
            cell.amount.text = GV.HomeScreen.predictedSpending
        case 2:
            cell.name.text = "Predicted Savings"
            cell.date.text = "of next month's income"
            cell.amount.text = GV.HomeScreen.predictedSavings
            
        default:
           return cell
        }
        
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
        //updateChartData(forPieChart: pieChart, labels: track, data: money)
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
        d.text = ""
        chart.chartDescription = d
        chart.centerText = "Pie Chart"
        chart.holeRadiusPercent = 0
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

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
