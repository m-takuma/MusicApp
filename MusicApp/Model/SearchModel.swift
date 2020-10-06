import Foundation
import Alamofire
import SwiftyJSON


class SearchModel:Secret{
    
    let secret = Secret()
    
    var apiKey = String()
    var resultCount = Int()
    var videoIDArray = [String()]
    var titleArray = [String()]
    var videoImageArray = [String()]
    
    
    
    
    override init() {
        self.apiKey = secret.YouTubeDataApiKey
        self.resultCount = 20
        self.videoIDArray = []
        self.titleArray = []
        self.videoImageArray = []
    }
    
    /*func makeSearchUrl(word:String,resultCount:Int) -> String {
        let url = "https://www.googleapis.com/youtube/v3/search?key=\(apiKey)&q=\(word)&part=snippet&fields=items(id,snippet/title,snippet/thumbnails/default),pageInfo/resultsPerPage&maxResults=\(resultCount)"
        let encodedUrl:String = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return encodedUrl
    }*/
    func makeSearchUrl(word:String) -> String {
        let url = "https://www.googleapis.com/youtube/v3/search?key=\(apiKey)&q=\(word)&part=snippet&fields=items(id,snippet/title,snippet/thumbnails/default),pageInfo/resultsPerPage&maxResults=\(resultCount)"
        let encodedUrl:String = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return encodedUrl
    }
    
    func StartParse(json:JSON) -> Void {
        let resultCount:Int = json["pageInfo"]["resultsPerPage"].int!
        reset()
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
    }
    func reset() -> Void {
        titleArray = []
        videoImageArray = []
        videoIDArray = []
    }
}
