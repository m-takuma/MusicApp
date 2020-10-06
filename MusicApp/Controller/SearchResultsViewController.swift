//
//  SearchResultsViewController.swift
//  MusicApp
//
//  Created by 松尾卓磨 on 2020/10/02.
//  Copyright © 2020 松尾卓磨. All rights reserved.
//

import UIKit
import SDWebImage
protocol CatchVideoID {
    func CatchVideoIdAndPlayVideo(Id:String)
}
class SearchResultsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var videotitleArray = [String()]
    var videoImageArray = [String()]
    var videoIdArray = [String()]
    

    @IBOutlet weak var searchResultsTabelView: UITableView!
    var delegate:CatchVideoID?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultsTabelView.delegate = self
        searchResultsTabelView.dataSource = self
        print(videotitleArray)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videotitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        print(videoImageArray[indexPath.row])
        Cell.videoImage.sd_setImage(with: URL(string: videoImageArray[indexPath.row]), completed: nil)
        Cell.videoTitle.text = videotitleArray[indexPath.row]
        
        return Cell
    }
    
    
    //cellがタップされたときのメソッドを探す//↓のメソッド
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //タップされたcellを判定して、VideoArrayの中からvideoIDを以前の
        let videoId:String = videoIdArray[indexPath.row]
        delegate?.CatchVideoIdAndPlayVideo(Id: videoId)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPushed(_ sender: Any) {
        reload()
    }
    func reload() -> Void {
        videotitleArray = videoIdArray
        searchResultsTabelView.reloadData()
    }
}
