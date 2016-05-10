//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Samuel Hinshelwood on 5/9/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    // if the url is set, fetch the image data at the url
    var imageURL: NSURL? {
        didSet {
            image = nil
            fetchImage()
        }
    }
    
    private var imageView = UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            // make the scrollView the size of the desired  image
            scrollView.contentSize = imageView.frame.size
                // do again, to ensure the frame is size is set when this outlet is loaded
            scrollView.delegate = self // send me (this class) any questions the scrollView might have
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 2.0
        }
    }
    
    // grab image data, create a UI image, and set it as this class's image
    private func fetchImage() {
        if let url = imageURL {
            if let imageData = NSData(contentsOfURL: url) {
                image = UIImage(data: imageData)
            }
        }
    }
    
    // MARK: - ScrollView Delegate Methods
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView // which of scrollView's subviews to zoom into
    }
    
    // if an image is set, display it in a imageView, change the scrollView size
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
                // ? b/c outlet might not be set when this happens
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
