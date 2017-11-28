//
//  SettingViewController.swift
//  SPam
//
//  Created by wsjung on 2017. 11. 27..
//  Copyright © 2017년 wsjung. All rights reserved.
//

import UIKit
import GoogleMobileAds
import MessageUI

class SettingViewController : UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        self.bannerView.adUnitID = "ca-app-pub-5111958533514037/2084741166"
        self.bannerView.rootViewController = self
        self.bannerView.delegate = self
        self.bannerView.load(GADRequest())
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            self.sendMail()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingCell
        
        let text : String!
        
        switch indexPath.row {
        case 0:
            text = "How to use : Setting -> Messages -> Unknown & Spam -> Filter Unknown Sender On , SPam Switch On"
            break
        case 1 :
            text = "Mail to developer"
            break
        case 2 :
            text = "Saving this number to your contacts is no longer classified as spam"
            break
        default:
            text = ""
        }
        
        cell.title.text = text
        return cell
    }
}

extension SettingViewController : GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("didFailToReceiveAdWithError")
    }
}

extension SettingViewController : MFMailComposeViewControllerDelegate {
    func sendMail(){
        let mailComposeViewController = self.initMailComposer()
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSetting()
        }
    }
    
    func showSetting(){
        let alertController = UIAlertController (title: "Mail setting error", message: "Go to Settings?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func initMailComposer() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setCcRecipients(["gguby11@gmail.com"])
        mailComposerVC.setSubject("To SPam developer")
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

class SettingCell : UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
}
