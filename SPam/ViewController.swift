//
//  ViewController.swift
//  SPam
//
//  Created by wsjung on 2017. 11. 27..
//  Copyright © 2017년 wsjung. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    let store  = CoreDataStack.store
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.bannerView.adUnitID = "ca-app-pub-5111958533514037/2084741166"
        self.bannerView.rootViewController = self
        self.bannerView.delegate = self
        self.bannerView.load(GADRequest())
        self.tableView.reloadData()
    }
    
    @IBAction func touchSeg(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
    @IBAction func addSpam(_ sender: UIButton) {
        
        let msg : String!
        if self.segmentControl.selectedSegmentIndex == 0 {
            msg = "Add phrases to filter"
        }else {
            msg = "Add number to filter"
        }
        
        let alert = UIAlertController(title: "Register", message: msg, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {
            (textField) in
                textField.text = ""
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            [weak alert] (_) in
                let textfield = alert?.textFields![0]
            if let text = textfield?.text {
                if self.segmentControl.selectedSegmentIndex == 0 {
                    self.store.storeContent(title: text)
                }else {
                    self.store.storeNumber(title: text)
                }
                
                self.tableView.reloadData()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       let index = self.segmentControl.selectedSegmentIndex
        
        if index == 0 {
            return store.contents.count
        }else {
            return store.numbers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SpamCell
        
        let idx = self.segmentControl.selectedSegmentIndex
        
        var title : String!
        
        if idx == 0 {
            let content = store.contents[indexPath.row]
            title = content.fileterString
        }else {
            let number = store.numbers[indexPath.row]
            title = number.number
        }
        
        cell.title.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            if self.segmentControl.selectedSegmentIndex == 0 {
                let obj = store.contents[indexPath.row]
                self.store.delete(spam: obj)
            }else {
                let obj = store.numbers[indexPath.row]
                self.store.delete(spam: obj)
            }
            
            self.tableView.reloadData()
        }
    }
}

extension ViewController : GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("didFailToReceiveAdWithError")
    }
}

class SpamCell : UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
}
