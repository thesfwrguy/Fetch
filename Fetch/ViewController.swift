//
//  ViewController.swift
//  Fetch
//
//  Created by Kanishka Goel on 2014-12-15.
//  Copyright (c) 2014 Kanishka Goel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, IMDbAPIControllerDelegate, UISearchBarDelegate {

    @IBOutlet var titleLabel        : UILabel?      //movie title
    @IBOutlet var releasedLabel     : UILabel?      //movie release date
    @IBOutlet var ratingLabel       : UILabel?      //movie rating
    @IBOutlet var plotLabel         : UILabel?      //movie plot
    @IBOutlet var posterImageView   : UIImageView?  //movie poster
    @IBOutlet var imdbSearchBar     : UISearchBar?
    @IBOutlet var metascoreLabel    : UILabel?      //movie metascore
    
    lazy var apiController: IMDbAPIController = IMDbAPIController(delegate: self)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.apiController.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "userTappedInView:")
        self.view.addGestureRecognizer(tapGesture)
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func didFinishIMDbSearch(result: Dictionary<String, String>) {
        
        self.titleLabel?.text       = result["Title"]
        self.releasedLabel?.text    = "Release Date: " + result["Released"]!
        self.ratingLabel?.text      = "IMDb Rating: " + result["imdbRating"]! + " with " + result["imdbVotes"]!
        self.plotLabel?.text        = result["Plot"]
        self.metascoreLabel?.text   = "Metascore: " + result["Metascore"]!
        
        if let foundPosterURL = result["Poster"]?{
            
            self.formatImageFromPath(foundPosterURL)
            
        }
        
    }
    
    func formatImageFromPath(path: String) {
        
        var posterURL                       = NSURL(string: path)
        var posterImageData                 = NSData(contentsOfURL: posterURL!)
        self.posterImageView?.clipsToBounds = true
        self.posterImageView?.image         = UIImage(data: posterImageData!)
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.apiController.searchIMDb(searchBar.text)
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    func userTappedInView(recognizer: UITapGestureRecognizer) {
        self.imdbSearchBar?.resignFirstResponder()
    }

}

