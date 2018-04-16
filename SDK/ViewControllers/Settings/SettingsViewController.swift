//
//  SettingsViewController.swift
//  iOS-SDK
//
//  Created by Balazs Vincze on 2018. 03. 29..
//  Copyright © 2018. SchedJoules. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // The API Key
    var accessToken: String!
    
    // Contact menu items
    let contactItems = ["FAQ", "Twitter", "Facebook", "Website"]
    // Contact menu item details
    let contactItemsDetail = [nil, "@schedjoules", "SchedJoules", "http://www.schedjoules.com"]
    // Contact menu item links to open
    let contactLinks = [URL(string: "https://cms.schedjoules.com/static_pages/help_\(Locale.preferredLanguages[0].components(separatedBy: "-")[0]).html"), URL(string:"https://twitter.com/SchedJoules"), URL(string:"https://www.facebook.com/SchedJoules/"), URL(string:"http://www.schedjoules.com")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set table view delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set navbar title
        navigationItem.title = "Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

// MARK: - Table View Delegate and Data Source
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        // Country & Language
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellDetail", for: indexPath)
            if indexPath.row == 0 {
                cell.textLabel!.text = "Country"
                if let countrySetting = UserDefaults.standard.value(forKey: "country_settings") as? Dictionary<String, String> {
                    cell.detailTextLabel!.text = countrySetting["displayName"]
                } else {
                    cell.detailTextLabel!.text = "Default"
                }
            } else {
                cell.textLabel!.text = "Language"
                if let languageSetting = UserDefaults.standard.value(forKey: "language_settings") as? Dictionary<String, String> {
                    cell.detailTextLabel!.text = languageSetting["displayName"]
                } else {
                    cell.detailTextLabel!.text = "Default"
                }
            }
            cell.detailTextLabel!.textColor = .lightGray
            return cell
        // FAQ & Social
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSubtitle", for: indexPath)
            cell.textLabel!.text = contactItems[indexPath.row]
            cell.detailTextLabel!.text = contactItemsDetail[indexPath.row]
            cell.imageView?.image = UIImage(named: contactItems[indexPath.row])
            cell.imageView?.tintColor = navigationController?.navigationBar.tintColor
            cell.detailTextLabel!.textColor = .lightGray
            return cell
        // About us
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSubtitle", for: indexPath)
            cell.textLabel!.text = "SchedJoules"
            cell.detailTextLabel!.text = nil
            cell.detailTextLabel!.textColor = .lightGray
            cell.imageView?.image = UIImage(named: "Icon")
            return cell
        }
       
    }
    
    // Headers for the table view sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "About us"
        case 1:
            return "Country & Language"
        default:
            return "Contact us"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        // About us
        case 0:
            let webVC = SettingsWebViewController()
            webVC.url = URL(string: "https://cms.schedjoules.com/static_pages/about_us_\(Locale.preferredLanguages[0].components(separatedBy: "-")[0]).html")
            webVC.navigationItem.title = "About us"
            navigationController?.pushViewController(webVC, animated: true)
        // Country & Language
        case 1:
            let storyBoard = UIStoryboard.init(name: "SDK", bundle: nil)
            let detailVC = storyBoard.instantiateViewController(withIdentifier: "SettingsLocalizationViewController") as! SettingsLocalizationViewController
            detailVC.accessToken = accessToken
            let rawValue = tableView.cellForRow(at: indexPath)!.textLabel!.text!.lowercased()
            detailVC.type = SettingsLocalizationViewController.DetailType(rawValue: rawValue)
            navigationController?.pushViewController(detailVC, animated: true)
        // FAQ & Social
        default:
            // FAQ
            if indexPath.row == 0 {
                let webVC = SettingsWebViewController()
                webVC.url = contactLinks[indexPath.row]!
                webVC.navigationItem.title = "FAQ"
                navigationController?.pushViewController(webVC, animated: true)
            // Other links
            } else {
                UIApplication.shared.open(contactLinks[indexPath.row]!, options: [:], completionHandler: nil)
            }
        }
    }
}
