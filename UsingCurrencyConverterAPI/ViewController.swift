//
//  ViewController.swift
//  UsingCurrencyConverterAPI
//
//  Created by Buse Köseoğlu on 10.02.2022.
//

import UIKit

struct Currency: Decodable{
    let base:String
    let date:String
    let rates:[String:Double]
}

class ViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textArea: UITextField!
    
    
    var currency : Currency?
    var baseRate = 1.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.allowsSelection = false
        textArea.textAlignment = .center
        
        fetchData()
        
    }

    @IBAction func convertClicked(_ sender: Any) {
        
        if let iGetString = textArea.text{
            if let isdouble = Double(iGetString){
                print(isdouble)
                baseRate = isdouble
                fetchData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currencyFetched = currency {
            return currencyFetched.rates.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: nil)
        
        if let currencyFetched = currency {
            cell.textLabel?.text = Array(currencyFetched.rates.keys)[indexPath.row]
            let selectedRate = baseRate * Array(currencyFetched.rates.values)[indexPath.row]
            cell.detailTextLabel?.text = "\(selectedRate)"
            return cell
        }
        return UITableViewCell()
    }
    
    func fetchData(){
        
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=0db71b91b3104562c627b215c59e7baf")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if error == nil{
                do{
                    self.currency = try JSONDecoder().decode(Currency.self, from: data!)
                }
                catch{
                    print("decode error")
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }else{
                print("error")
            }
        }.resume()
        
    }
    
}


