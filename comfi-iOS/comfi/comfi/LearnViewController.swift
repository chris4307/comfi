//
//  LearnViewController.swift
//  comfi
//
//  Created by Brian Li on 11/6/18.
//

import UIKit

class LearnViewController: UIViewController {

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSegmentedControl()
        configureTableView()
    }
    
    func configureSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(LearnViewController.segmentedControlDidChange), for: .valueChanged)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    @objc func segmentedControlDidChange() {
        tableView.reloadData()
        tableView.reloadSections([0,1], with: .automatic)
        print(GV.LearnScreen.strengths)
        print(GV.LearnScreen.weaknesses)
        print(GV.LearnScreen.canHelp)
        print(GV.LearnScreen.getHelp)
    }
}

extension LearnViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("selected segment is \(segmentedControl.selectedSegmentIndex)")
        if segmentedControl.selectedSegmentIndex == 0 {
            return 2
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return 2
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            switch section {
            case 0:
                return GV.LearnScreen.strengths.count
            case 1:
                return GV.LearnScreen.weaknesses.count
            default:
                return 0
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            switch section {
            case 0:
                return GV.LearnScreen.getHelp.count
            case 1:
                return GV.LearnScreen.canHelp.count
            default:
                return 0
            }
        } else {
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segmentedControl.selectedSegmentIndex == 0 {
            switch section {
            case 0:
                print("should display strengths")
                return "Strengths"
            case 1:
                return "Weaknesses"
            default:
                return nil
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            switch section {
            case 0:
                return "Get Advice From..."
            case 1:
                return "Give Advice To..."
            default:
                return nil
            }
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // TODO: implement dequeue to improve efficiency
        
        // strengths and weaknesses section
        if segmentedControl.selectedSegmentIndex == 0 {
            let cell = UITableViewCell()
            
            switch indexPath.section {
            case 0:
                print("strength is \(GV.LearnScreen.strengths[indexPath.row])")
                cell.textLabel?.text = GV.LearnScreen.strengths[indexPath.row]
                
                cell.selectionStyle = .none
                return cell
            case 1:
                print("weakness is \(GV.LearnScreen.weaknesses[indexPath.row])")
                cell.textLabel?.text = GV.LearnScreen.weaknesses[indexPath.row]
                
                cell.selectionStyle = .none
                return cell
            default:
                return cell
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let cell = UITableViewCell()
            
            switch indexPath.section {
            case 0:
                var personData = GV.LearnScreen.getHelp[indexPath.row]
                var person: User = GV.getUser(fromID: personData["fbid"] as! String)!
                cell.imageView?.image = person.profilePhoto
                
                let categories = personData["categories"] as! [String]
                
                let nameString = person.first_name + " " + person.last_name
                
                var categoriesString = " ("
                for i in 0...(categories.count - 1) {
                    if(i == categories.count - 1) {
                        categoriesString += categories[i]
                    } else {
                        categoriesString += categories[i] + ", "
                    }
                }
                categoriesString += ")"
                
                let categoriesMutableText = NSMutableAttributedString(string: categoriesString)
                categoriesMutableText.addAttributes([.foregroundColor: UIColor.lightGray], range: NSMakeRange(0, categoriesMutableText.length))
                
                let mutableText = NSMutableAttributedString(string: nameString)
                
                mutableText.append(categoriesMutableText)
                
                cell.textLabel?.attributedText = mutableText
                
                cell.selectionStyle = .none
                return cell
            case 1:
                var personData = GV.LearnScreen.canHelp[indexPath.row]
                var person: User = GV.getUser(fromID: personData["fbid"] as! String)!
                cell.imageView?.image = person.profilePhoto
                
                let categories = personData["categories"] as! [String]
                
                let nameString = person.first_name + " " + person.last_name
                
                var categoriesString = " ("
                for i in 0...(categories.count - 1) {
                    if(i == categories.count - 1) {
                        categoriesString += categories[i]
                    } else {
                        categoriesString += categories[i] + ", "
                    }
                }
                categoriesString += ")"
                
                let categoriesMutableText = NSMutableAttributedString(string: categoriesString)
                categoriesMutableText.addAttributes([.foregroundColor: UIColor.lightGray], range: NSMakeRange(0, categoriesMutableText.length))
                
                let mutableText = NSMutableAttributedString(string: nameString)
                
                mutableText.append(categoriesMutableText)
                
                cell.textLabel?.attributedText = mutableText
                
                cell.selectionStyle = .none
                return cell
            default:
                return cell
            }
        } else {
            
        }
        
        return UITableViewCell()
    }
}
