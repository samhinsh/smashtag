//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Samuel Hinshelwood on 5/4/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    // apply formatting to the desired string and return string
    private func applyTweetTextFormatting(tweet: Twitter.Tweet, text: String) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: text)
        
        // hashtag formats
        for hashtag in tweet.hashtags {
            attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: hashtag.nsrange)
        }
        
        // url formats
        for url in tweet.urls {
            attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.brownColor(), range: url.nsrange)
        }
        
        // user mentions
        for userMention in tweet.userMentions {
            attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: userMention.nsrange)
        }
        
        return attributedText
    }
    
    private func updateUI() {
        
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            var text = tweet.text
            for _ in tweet.media {
                text += " 📷"
            }
            
            tweetTextLabel.attributedText = applyTweetTextFormatting(tweet, text: text)
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = NSData(contentsOfURL: profileImageURL) { // blocks main thread!
                    tweetProfileImageView?.image = UIImage(data: imageData)
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
        
    }
    
}
