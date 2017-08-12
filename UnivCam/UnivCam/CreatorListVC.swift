//
//  SettingViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class CreatorListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var developers = ["개발자 1", "개발자 2", "개발자 3", "디자이너"]
    
    let llb = ["이름", "이메일", "Github"] // Left Label
    
    let cjy = ["조준영", "pom0894@naver.com", "chojunyoung"] // Delveloper Cho Jun Yeong's Info
    let ljs = ["이준상", "zun8ang@gmail.com", "zun8ang"] // Developer Lee Jun Sang's Info
    let cym = ["조용문", "choymoonk@gmail.com", "choymoon"] // Developer Cho Young Moon's Info
    let sh = ["서혁", "ghsspower@gmail.com", "spemer"] // Designer Seo Hyouk's Info
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return developers.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.developers[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.5
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeveloperInfoCell", for: indexPath) as! DeveloperInfoCell
        cell.leftLabel.text! = llb[indexPath.row]
        cell.rightLabel.text! = cjy[indexPath.row]
        
        return cell
    }
    
    
}

