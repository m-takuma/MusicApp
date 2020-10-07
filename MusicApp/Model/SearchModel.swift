import Foundation
import Alamofire
import SwiftyJSON

class SearchModel{
    
    let secret = Secret()
    
    var apiKey = String()
    var resultCount = Int()
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
    
    func makeSearchUrl(word:String,resultCount:Int) -> String {
        self.word = word
        let url = "https://www.googleapis.com/youtube/v3/search?key=\(apiKey)&q=\(word)&part=snippet&fields=items(id,snippet/title,snippet/thumbnails/default),pageInfo/resultsPerPage&maxResults=\(resultCount)"
        let encodedUrl:String = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return encodedUrl
    }
    func makeSearchUrl(word:String,pageToken:String) -> String {
        self.word = word
        let url = "https://www.googleapis.com/youtube/v3/search?key=\(apiKey)&q=\(word)&part=snippet&fields=items(id,snippet/title,snippet/thumbnails/default),pageInfo/resultsPerPage,nextPageToken,prevPageToken&maxResults=\(resultCount)&pageToken=\(pageToken)"
        let encodedUrl:String = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return encodedUrl
    }
    func makeSearchUrl(word:String) -> String {
        self.word = word
        let url = "https://www.googleapis.com/youtube/v3/search?key=\(apiKey)&q=\(word)&part=snippet&fields=items(id,snippet/title,snippet/thumbnails/default),pageInfo/resultsPerPage,nextPageToken,prevPageToken&maxResults=\(resultCount)"
        let encodedUrl:String = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return encodedUrl
    }
    
    
    func StartParse(json:JSON) -> Bool {
        print(json)
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
    func reset() -> Void {
        titleArray = []
        videoImageArray = []
        videoIDArray = []
    }
    
}
