//
//  ViewController.swift
//  RandomMovie
//
//  Created by Adrian Garcia Rios on 3/22/22.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieRT: UILabel!
    @IBOutlet weak var movieMetascore: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieGenre: UILabel!
   
    
    //let randomID = Int.random(in: 0000001...5000000)
    var defaultImage = "default-movie.jpeg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getMovie()
    }
    
    //get api data
    private func getData(from url: String){
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            
            guard let data = data, error == nil else{
                print("something went wrong")
                return
            }
            
            //have data
            var result: Movie?
            do{
                result = try JSONDecoder().decode(Movie.self, from: data)
            }
            catch{
                debugPrint(error)
                /*var randomID = Int.random(in: 0000001...5000000)
                let id = String(format: "%07d", randomID)
                let url = "https://www.omdbapi.com/?i=tt\(id)&type=movie&apikey=c1babfe4"
                self.getData(from: url)*/
                self.getMovie()
            }
            
            guard let json = result else {
                return
            }
            
            print(json._Type)
            if (json._Type == "movie"){
                DispatchQueue.main.async {
                    self.movieTitle.text = json.Title
                    self.movieYear.text = json.Year
                    self.movieRT.text = json.Rated
                    self.movieMetascore.text = json.Metascore
                    self.movieGenre.text = json.Genre
                    
                    //self.moviePoster.image = UIImage(named: json.Poster)
                    //let movieUrl = json.Poster
                    if (json.Poster == "N/A"){
                        self.moviePoster.image = UIImage(named: self.defaultImage)
                    } else {
                        if let data = try? Data(contentsOf: URL(string: json.Poster)!){
                            self.moviePoster.image = UIImage(data: data)
                        }
                    }
                }
            } else{
                self.getMovie()
            }
           
            
        })
        task.resume()
        
    }

    //calls getMovie to generate a new movie
    @IBAction func btnTouch(_ sender: Any) {
       /* var randomID = Int.random(in: 0000001...5000000)
        let id = String(format: "%07d", randomID)
        print(id)
        let url = "https://www.omdbapi.com/?i=tt\(id)&type=movie&apikey=c1babfe4"
        getData(from: url) */
        
        getMovie()
    }
    
    
    //generates a movie
    private func getMovie(){
        let randomID = Int.random(in: 0000001...5000000)
        let id = String(format: "%07d", randomID)
        print(id)
        let url = "https://www.omdbapi.com/?i=tt\(id)&apikey=c1babfe4&type=movie"
        getData(from: url)
        
    }
}

struct Movie: Codable{
    //let Search: MovieList
    let Title:String
    let Year:String
    let Rated:String
    let Metascore:String
    let _Type:String
    let Poster:String
    let imdbID: String
    let Genre:String
    
    private enum CodingKeys: String, CodingKey {
        case Title, Year, Rated, Metascore, _Type = "Type", Poster, imdbID, Genre
    }
}

/*struct MovieList: Codable{
    let Title:String
    let Year:String
    let Rate:String
    let Metascore:String
}*/
