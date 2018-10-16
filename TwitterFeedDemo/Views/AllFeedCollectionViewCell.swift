//
//  AllFeedCollectionViewCell.swift
//  TwitterFeedDemo
//
//  Created by apple on 10/11/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import TwitterKit
import MapKit

class AllFeedCollectionViewCell: UITableViewCell {

    var post:FacebookFeed?
    var tweet:TWTRTweet?
    
    @IBOutlet weak var mediaImageHeight: NSLayoutConstraint!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var typeIcon: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        userName.text = nil
        screenName.text = nil
        typeIcon.image = nil
        message.text = nil
        mediaImageView.image = nil
        descLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        screenName.translatesAutoresizingMaskIntoConstraints = false
        typeIcon.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        mediaImageView.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mediaImageView.superview?.bringSubviewToFront(mediaImageView)
        mediaImageView.backgroundColor = .white
    }

    func set(post:FacebookFeed?){
        self.post = post
        
        if let name = post?.name {
            
            let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            
            if let city = post?.place?.location?.city, let state = post?.place?.location?.country {
                attributedText.append(NSAttributedString(string: "\n\(city), \(state)  •  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor:
                    UIColor.rgb(155, green: 161, blue: 161)]))
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                
                attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
                
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "globe_small")
                attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
                attributedText.append(NSAttributedString(attachment: attachment))
            }
            userName.attributedText = attributedText
        }
        mediaImageHeight.constant = 125
        if let imageUrl = post?.full_picture{
            self.mediaImageView.downloaded(from: imageUrl)
            self.mediaImageView.superview?.bringSubviewToFront(mediaImageView)
        }else if let latitude = post?.place?.location?.latitude, let longitude = post?.place?.location?.longitude{
            let coord = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            mapView.zoom(toCenterCoordinate: coord, zoomLevel: 10)            
            descLabel.text = post?.place?.name
            self.mapView.superview?.bringSubviewToFront(mapView)
        }else{
            mediaImageHeight.constant = 0
        }
        message.text = post?.message
        descLabel.text = post?._description
    }    
}

