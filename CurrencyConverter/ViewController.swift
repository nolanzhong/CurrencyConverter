//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Nolan Zhong on 3/17/23.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var chfLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var usdLabe: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var semaphore = DispatchSemaphore (value: 0)
    @IBAction func getRatesClicked(_ sender: Any) {
        // 1) Create Requestion & Session
        // 2) Response & Data
        // 3) Parsing & JSON Serialization
        
        let url = "https://api.apilayer.com/fixer/latest?symbols=CAD%2CCHF%2CGBP%2CJPY%2CUSD%2CTRY&base=EUR"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue("UKYtpnDCIILTOjPehl55OSQDKElms9d2", forHTTPHeaderField: "apikey")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                return
          }
            //print(String(data: data, encoding: .utf8)!)
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                
                //ASYNC
                DispatchQueue.main.async {
                    print(jsonResponse)
                    if let rates = jsonResponse["rates"] as? [String: Any] {
                        if let cad = rates["CAD"] as? Double {
                            self.cadLabel.text = "CAD: \(cad)"
                        }
                    }
                    
                    if let rates = jsonResponse["rates"] as? [String: Any] {
                        if let chf = rates["CHF"] as? Double {
                            self.chfLabel.text = "CHF: \(chf)"
                        }
                    }
                    
                    if let rates = jsonResponse["rates"] as? [String: Any] {
                        if let gbp = rates["GBP"] as? Double {
                            self.gbpLabel.text = "GBP: \(gbp)"
                        }
                    }
                    
                    if let rates = jsonResponse["rates"] as? [String: Any] {
                        if let jpy = rates["JPY"] as? Double {
                            self.jpyLabel.text = "JPY: \(jpy)"
                        }
                    }
                    
                    if let rates = jsonResponse["rates"] as? [String: Any] {
                        if let usd = rates["USD"] as? Double {
                            self.usdLabe.text = "USD: \(usd)"
                        }
                    }
                    
                    if let rates = jsonResponse["rates"] as? [String: Any] {
                        if let turkish = rates["TRY"] as? Double {
                            self.tryLabel.text = "TRY: \(turkish)"
                        }
                    }
                }
                
            } catch {
                print("error")
            }
            self.semaphore.signal()
        }
        
        task.resume()
        self.semaphore.wait()
    }
    
}

