//
//  ViewController.swift
//  MusicApp
//
//  Created by 松尾卓磨 on 2020/09/28.
//  Copyright © 2020 松尾卓磨. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import Foundation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, YTPlayerViewDelegate,UITextFieldDelegate,CatchVideoID{
    let searchmodel = SearchModel()
    var videotitleArray = [String()]
    var videoImageArray = [String()]
    var videoIdArray = [String()]
    
    @IBOutlet weak var youtubeview: YTPlayerView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.youtubeview.delegate = self
        searchTextField.delegate = self//画面読み込み時のところに書く
        self.youtubeview.load(withVideoId: "_RmyFTG0F_c", playerVars: ["playsinline":1])
        // Do any additional setup after loading the view.
    }

    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {//動画再生の準備ができたときの処理
        self.youtubeview.playVideo()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //searchmodel.search(word: textField.text!)
        return textField.resignFirstResponder()
    }

    @IBAction func PushedSearchButton(_ sender: UIButton) {
        view.endEditing(true)
        let encodedUrl = searchmodel.makeSearchUrl(word: searchTextField.text!)
        AF.request(encodedUrl,method: .get,parameters: nil,encoding: JSONEncoding.default).responseJSON { (res) in
            switch res.result{
            case .success:
                let json:JSON = JSON(res.data as Any)
                print(json)
                self.searchmodel.StartParse(json: json)
                self.videotitleArray = self.searchmodel.titleArray
                self.videoImageArray = self.searchmodel.videoImageArray
                self.videoIdArray = self.searchmodel.videoIDArray
                print(self.videoIdArray)
                self.performSegue(withIdentifier: "id", sender: nil)
            case .failure(_):
                print("エラー")
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "id"{
            let tableVC = segue.destination as! SearchResultsViewController
            tableVC.delegate = self
            tableVC.videotitleArray = self.videotitleArray
            tableVC.videoImageArray = self.videoImageArray
            tableVC.videoIdArray = self.videoIdArray
        }
    }
    func CatchVideoIdAndPlayVideo(Id: String) {
        self.youtubeview.load(withVideoId: Id, playerVars: ["playsinline":1])
    }
}

