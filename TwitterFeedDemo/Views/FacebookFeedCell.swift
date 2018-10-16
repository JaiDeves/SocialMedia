//
//  FacebookFeedCell.swift
//  TwitterFeedDemo
//
//  Created by apple on 10/12/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import TwitterKit
import MapKit
class FacebookFeedCell: UITableViewCell {

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
        time.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.image = nil
        userName.text = nil
        screenName.text = nil
        message.text = nil
        mediaImageView.image = nil
        descLabel.text = nil
        time.text = nil
        
        mediaImageView.superview?.bringSubviewToFront(mediaImageView)
        mediaImageView.backgroundColor = .white
    }
    
    func set(post:FacebookFeed?){
        self.post = post
        typeIcon.image = UIImage(named: "facebook_logo")
        if let name = post?.from?.name {
            
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



extension MKMapView {
    var MERCATOR_OFFSET : Double {
        return 268435456.0
    }
    
    var MERCATOR_RADIUS : Double  {
        return 85445659.44705395
    }
    
    private func longitudeToPixelSpaceX(longitude: Double) -> Double {
        return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0)
    }
    
    private func latitudeToPixelSpaceY(latitude: Double) -> Double {
        return round(MERCATOR_OFFSET - MERCATOR_RADIUS * log((1 + sin(latitude * M_PI / 180.0)) / (1 - sin(latitude * M_PI / 180.0))) / 2.0)
    }
    
    private  func pixelSpaceXToLongitude(pixelX: Double) -> Double {
        return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI;
    }
    
    private func pixelSpaceYToLatitude(pixelY: Double) -> Double {
        return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI;
    }
    
    private func coordinateSpan(withMapView mapView: MKMapView, centerCoordinate: CLLocationCoordinate2D, zoomLevel: UInt) ->MKCoordinateSpan {
        let centerPixelX = longitudeToPixelSpaceX(longitude: centerCoordinate.longitude)
        let centerPixelY = latitudeToPixelSpaceY(latitude: centerCoordinate.latitude)
        
        let zoomExponent = Double(20 - zoomLevel)
        let zoomScale = pow(2.0, zoomExponent)
        
        let mapSizeInPixels = mapView.bounds.size
        let scaledMapWidth =  Double(mapSizeInPixels.width) * zoomScale
        let scaledMapHeight = Double(mapSizeInPixels.height) * zoomScale
        
        let topLeftPixelX = centerPixelX - (scaledMapWidth / 2);
        let topLeftPixelY = centerPixelY - (scaledMapHeight / 2);
        
        //    // find delta between left and right longitudes
        let minLng = pixelSpaceXToLongitude(pixelX: topLeftPixelX)
        let maxLng = pixelSpaceXToLongitude(pixelX: topLeftPixelX + scaledMapWidth)
        let longitudeDelta = maxLng - minLng;
        
        let minLat = pixelSpaceYToLatitude(pixelY: topLeftPixelY)
        let maxLat = pixelSpaceYToLatitude(pixelY: topLeftPixelY + scaledMapHeight)
        let latitudeDelta = -1 * (maxLat - minLat);
        
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        return span
    }
    
    func zoom(toCenterCoordinate centerCoordinate:CLLocationCoordinate2D ,zoomLevel: UInt) {
        let zoomLevel = min(zoomLevel, 20)
        let span = self.coordinateSpan(withMapView: self, centerCoordinate: centerCoordinate, zoomLevel: zoomLevel)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        self.setRegion(region, animated: true)
        
    }
}
