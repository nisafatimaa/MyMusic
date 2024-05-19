import UIKit

class ViewController: UIViewController {
   
    @IBOutlet var table : UITableView!

    var mySongs = MySongs()
    var songs : [SongModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        
        songs.append(contentsOf: mySongs.mySongs)
        
    }
}


// MARK: - Table View Delegate
extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let position = indexPath.row
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "player")as? PlayerViewController else { return }
        vc.position = position
        vc.songs = songs
        present(vc, animated: true)
        table.deselectRow(at: indexPath, animated: true)
    }
}
 

// MARK: - Table View DataSource
extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
        cell.textLabel?.text = song.songName
        cell.detailTextLabel?.text = song.albumName
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: song.imageName)
        
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.detailTextLabel?.font = UIFont(name:"Helvetica", size: 17)
        
        return cell
    }
}
