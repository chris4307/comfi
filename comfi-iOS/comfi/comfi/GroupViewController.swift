//
//  GroupViewController.swift
//  comfi
//
//  Created by Brian Li on 10/14/18.
//

import UIKit
import Charts

class GroupViewController: UIViewController {
    
    var pieChart = PieChartView()
    @IBOutlet var chartView: UIView!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTableView()
        configurePieChart()
        
        var labels: [String] = []
        var data: [Double] = []
        for(key, value) in GV.GroupScreen.pieChartDict {
            labels.append(key)
            data.append(value)
        }
        
        updateChartData(forPieChart: pieChart, labels: labels, data: data)
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CompetitorTableViewCell", bundle: nil), forCellReuseIdentifier: "CompetitorTableViewCell")
        
        // remove empty cells
        tableView.tableFooterView = UIView()
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

extension GroupViewController: ChartViewDelegate {
    
    func configurePieChart() {
        self.setup(pieChartView: pieChart)
        pieChart.delegate = self
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
        
        let set = PieChartDataSet(values: entries, label: "Pie Chart")
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
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("\n\nclicked")
        print(entry.description)
        print(entry.x)
        
    }
}
