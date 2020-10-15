import UIKit

protocol CatchVideoInfoDelegate {
    func catchVideoInfo(at:Int) -> (id:String,title:String,image:String)
}

class TableViewCell: UITableViewCell{
    
    @IBOutlet weak var videoImage: UIImageView!
    
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var playlistButton: UIButton!
    
    let playlistModel = PlaylistModel()
    var delegate:CatchVideoInfoDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func playlistButtonPushed(_ sender: UIButton) {
        let videoInfo = delegate?.catchVideoInfo(at: sender.tag)
        let plusOrDelete = playlistModel.searchMusic(id: videoInfo!.id)
        if plusOrDelete {
            playlistModel.deleteMusicFromPlaylist(id: videoInfo!.id)
            sender.setImage(UIImage(systemName: "plus"), for: .normal)
        }else{
            playlistModel.addMusicToPlaylist(id: videoInfo!.id, title: videoInfo!.title, image: videoInfo!.image)
            sender.setImage(UIImage(systemName: "delete.left"), for: .normal)
        }
    }
    
}
