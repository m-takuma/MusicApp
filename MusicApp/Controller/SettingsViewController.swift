//
//  SettingsViewController.swift
//  MusicApp
//
//  Created by 松尾卓磨 on 2020/10/21.
//  Copyright © 2020 松尾卓磨. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var settingTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableview.delegate = self
        settingTableview.dataSource = self
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "設定"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(index: indexPath)
        return cell
    }
    func makeCell(index:IndexPath) -> UITableViewCell {
        let cell = settingTableview.dequeueReusableCell(withIdentifier: "settingCell", for: index)
        let width:CGFloat = 50
        let height:CGFloat = 30
        let loopSwitch:UISwitch = UISwitch(frame: CGRect(x: CGFloat(Int(cell.bounds.maxX) - Int(cell.bounds.width) / 20 - Int(width)), y: CGFloat(cell.bounds.midY - 15), width: width, height: height))
        loopSwitch.addTarget(self, action: #selector(changeSwith), for: UIControl.Event.valueChanged)
        if let onOrOff:Bool = UserDefaults.standard.object(forKey: "loop") as? Bool{
            loopSwitch.setOn(onOrOff, animated: false)
        }else{
            loopSwitch.setOn(false, animated: false)
        }
        cell.addSubview(loopSwitch)
        cell.textLabel?.text = "一曲ループ再生をONにする"
        return cell
    }
    
    @objc func changeSwith(sender:UISwitch){
        let onCheck:Bool = sender.isOn
        UserDefaults.standard.setValue(onCheck, forKey: "loop")
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
