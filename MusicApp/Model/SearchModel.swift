//
//  SearchModel.swift
//  MusicApp
//
//  Created by 松尾卓磨 on 2020/10/21.
//  Copyright © 2020 松尾卓磨. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON

class SearchModel{
    
    private let secret = Secret()
    
    private var apiKey = String()
    private var resultCount = Int()
    var videoIDArray = [String()]
    var titleArray = [String()]
    var videoImageArray = [String()]
    var nextPageToken = String()
    var prevPageToken = String()
    var word = String()
    var errorCode = Int()
    
    
    
    
    init() {
        self.apiKey = secret.YouTubeDataApiKey
        self.resultCount = 20
        self.videoIDArray = []
        self.titleArray = []
        self.videoImageArray = []
    }
    
    /*YouTubeDataApiでワード検索するメソッド*/
    
    func makeSearchUrl(word:String,resultCount:Int) -> String {
        self.word = word
        let type = "video"
        let url = "https://www.googleapis.com/youtube/v3/search?key=\(apiKey)&q=\(word)&part=snippet&fields=items(id,snippet/title,snippet/thumbnails/default),pageInfo/resultsPerPage,nextPageToken,prevPageToken&maxResults=\(resultCount)&type=\(type)"
        let encodedUrl:String = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return encodedUrl
    }
    func makeSearchUrl(word:String,pageToken:String) -> String {
        self.word = word
        let type = "video"
        let url = "https://www.googleapis.com/youtube/v3/search?key=\(apiKey)&q=\(word)&part=snippet&fields=items(id,snippet/title,snippet/thumbnails/default),pageInfo/resultsPerPage,nextPageToken,prevPageToken&maxResults=\(resultCount)&type=\(type)&pageToken=\(pageToken)"
        let encodedUrl:String = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return encodedUrl
    }
    func makeSearchUrl(word:String) -> String {
        self.word = word
        let type = "video"
        let url = "https://www.googleapis.com/youtube/v3/search?key=\(apiKey)&q=\(word)&part=snippet&fields=items(id,snippet/title,snippet/thumbnails/default),pageInfo/resultsPerPage,nextPageToken,prevPageToken&maxResults=\(resultCount)&type=\(type)"
        let encodedUrl:String = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return encodedUrl
    }
    
    /*makeSearchUrl()から得られたurlにアクセスして得られるjsonを解析するメソッド
     返り値は正しく解析できたかどうか
     YouTubeDataApi用
     */
    func StartParse(json:JSON) -> Bool {
        guard let resultCount:Int = json["pageInfo"]["resultsPerPage"].int else{
            errorCode = json["error"]["code"].int!
            return false
        }
        reset()
        if json["nextPageToken"].string != nil {
            nextPageToken = json["nextPageToken"].string!
        }else{
            nextPageToken = ""
        }
        if json["prevPageToken"].string != nil {
            prevPageToken = json["prevPageToken"].string!
        }else{
            prevPageToken = ""
        }
        
        for i in 0 ..< resultCount {
            let kind = json["items"][i]["id"]["kind"].string
            switch kind {
            case "youtube#channel":
                break
            case "youtube#video":
                let videoTitle = json["items"][i]["snippet"]["title"].string
                let videoImageUrl = json["items"][i]["snippet"]["thumbnails"][ "default"]["url"].string
                let videoId = json["items"][i]["id"]["videoId"].string
                
                titleArray.append(videoTitle!)
                videoImageArray.append(videoImageUrl!)
                videoIDArray.append(videoId!)
            default: break
            }
        }
        return true
    }
    
    /*YouTubeDataApi用の格納配列のリセットメソッド
     
     */
    private func reset() -> Void {
        titleArray = []
        videoImageArray = []
        videoIDArray = []
    }
    
}
