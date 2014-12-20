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
    @IBOutlet var subtitleLabel     : UILabel?      
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
        
        if let foundTitle = result["Title"] {
            parseTitleFromSubtitle(foundTitle)
        }
        
        self.releasedLabel?.text    = "Release Date: " + result["Released"]!
        self.ratingLabel?.text      = "IMDb Rating: " + result["imdbRating"]! + " with " + result["imdbVotes"]!
        self.plotLabel?.text        = result["Plot"]
        self.metascoreLabel?.text   = "Metascore: " + result["Metascore"]!
        
        
        if let foundPosterURL = result["Poster"]?{
            
            self.formatImageFromPath(foundPosterURL)
            
        }
        
    }
    
    func parseTitleFromSubtitle(title: String) {
        
        var index = title.findIndexOf(":")
        if let foundIndex = index? {
            
            var newTitle                = title[0..<foundIndex]
            var subtitle                = title[foundIndex + 2..<countElements(title)]
            
            self.titleLabel?.text       = newTitle
            self.subtitleLabel?.text    = subtitle
            
        } else {
            
            self.titleLabel?.text       = title
            self.subtitleLabel?.text    = ""
            
        }
        
    }
    
    func formatImageFromPath(path: String) {
        
        var posterURL                       = NSURL(string: path)
        var posterImageData                 = NSData(contentsOfURL: posterURL!)
        self.posterImageView?.clipsToBounds = true
        self.posterImageView?.image         = UIImage(data: posterImageData!)
        
        if let imageToBlur = self.posterImageView?.image {
            
            self.blurBackgroundUsingImage(imageToBlur)
            
        }
    }
    
    func blurBackgroundUsingImage(image: UIImage) {
        //capsture the size of our view to reuse where needed
        var frame                               = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        var imageView                           = UIImageView(frame: frame)
        imageView.image                         = image;
        
        //manually set 'Aspect fill' mode for the background
        imageView.contentMode                   = .ScaleAspectFill
        
        //set the UIBlurEffect and then the UIVisualEffectView by passing it the UIBlurEffect
        var blurEffect                          = UIBlurEffect(style: .Light)
        var blurEffectView                      = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame                    = frame
        
        var transparentWhiteView                = UIView(frame: frame)
        transparentWhiteView.backgroundColor    = UIColor(white: 1.0, alpha: 0.30)
        
        //add the above created views to our view
        var viewsArray                          = [imageView, blurEffectView, transparentWhiteView]
        
        for index in 0..<viewsArray.count {
            
            if let oldView = self.view.viewWithTag(index + 1) {
                
                var oldView = self.view.viewWithTag(index + 1)
                oldView!.removeFromSuperview()
                
            }
            var viewToInsert = viewsArray[index]
            self.view.insertSubview(viewToInsert, atIndex: index + 1)
            viewToInsert.tag = index + 1
        }
        
        
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

