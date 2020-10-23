//
//  PlaylistViewController.swift
//  MusicApp
//
//  Created by 松尾卓磨 on 2020/10/15.
//  Copyright © 2020 松尾卓磨. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CatchVideoInfoDelegate {
    
    
    
    @IBOutlet weak var playlistTableview: UITableView!
    
    let playlistModel = PlaylistModel()
    var videotitleArray:Array<String> = []
    var videoImageArray:Array<String> = []
    var videoIdArray:Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistTableview.delegate = self
        playlistTableview.dataSource = self
        playlistTableview.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    override func viewWillAppear(_ animated: Bool) {
        playlistTableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let musicIdKeyArray = UserDefaults.standard.stringArray(forKey: playlistModel.KEY) else {
            return 0
        }
        videoIdArray = []
        videotitleArray = []
        videoImageArray = []
        for i in 0 ..< musicIdKeyArray.count {
            let idKey = musicIdKeyArray[i]
            let videoInfo = UserDefaults.standard.dictionary(forKey: idKey)
            videoIdArray.append(videoInfo!["id"] as! String)
            videotitleArray.append(videoInfo!["title"] as! String)
            videoImageArray.append(videoInfo!["image"] as! String)
        }
        return videoIdArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        Cell.delegate = self
        Cell.videoImage.sd_setImage(with: URL(string: videoImageArray[indexPath.row]), completed: nil)
        Cell.videoTitle.text = videotitleArray[indexPath.row]
        Cell.playlistButton.tag = indexPath.row
        let plusOrDelete = Cell.playlistModel.searchMusic(id: videoIdArray[indexPath.row])
        if plusOrDelete {//true -> playlistにある　false -> playlistにない
            Cell.playlistButton.setImage(UIImage(systemName: "delete.left"), for: .normal)
        }else{
            Cell.playlistButton.setImage(UIImage(systemName: "plus"), for: .normal)
        }
        return Cell
    }
    func catchVideoInfo(at: Int) -> (id: String, title: String, image: String) {
        let id = self.videoIdArray[at]
        let title = self.videotitleArray[at]
        let image = self.videoImageArray[at]
        let videoInfo = (id:id,title:title,image:image)
        return videoInfo
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = videoIdArray[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let PlaylistVC = storyboard.instantiateViewController(withIdentifier: "playVC") as! ViewController
        let delegate:ViewController? = PlaylistVC
        delegate?.CatchVideoIdAndPlayVideo(Id: id)
    }
}
