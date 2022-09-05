//
//  ViewController.swift
//  Project4
//
//  Created by TwoStraws on 13/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   
    var websites = ["apple.com","hackingwithswift.com","twitter.com"]
    
    //MARK: IBOutlet
    
    @IBOutlet weak var myTableView: UITableView!
    let webView = WebVC()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        
    }
    
    // MARK: protocole
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        websites.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = websites[indexPath.row]
        if #available(iOS 13.0, *) {
            if let vc = storyboard?.instantiateViewController(identifier: "WebVC") as? WebVC {
                vc.websites = websites
                vc.web = selected
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            // Fallback on earlier versions
            let storyboard = UIStoryboard(name: "myStoryboardName", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WebVC") as? WebVC
            vc!.websites = websites
            vc!.web = selected
            self.present(vc!, animated: true)
        }
    }
}
