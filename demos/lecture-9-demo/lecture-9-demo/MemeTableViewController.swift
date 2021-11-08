//
//  ViewController.swift
//  lecture-9-demo
//
//  Created by Misty Liao on 11/7/21.
//

import UIKit
import Kingfisher
import Alamofire

struct Meme: Codable {
    
    let id: String
    let name: String
    let image: URL
    
    enum CodingKeys: String, CodingKey {
        case image = "url"
        case id, name
    }
}

struct MemeCollection: Codable {
    var data: Data
    struct Data: Codable {
        var memes: [Meme]
    }
}

class MemeTableViewController: UITableViewController {
    
    var memes = [Meme]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMemes()
    }
    
    private func fetchMemes() {
        
        let urlString = "https://api.imgflip.com/get_memes"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let decodedMemes = try? JSONDecoder().decode(MemeCollection.self, from: data) {
                    self.memes = decodedMemes.data.memes
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        task.resume()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        
        cell.textLabel?.text = meme.name
        cell.detailTextLabel?.text = meme.id
        cell.imageView?.kf.setImage(with: meme.image)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }


}
