//
//  RVBadgeViewController.swift
//  Challenge
//
//  Created by Rohan Vasavada on 9/20/19.
//  Copyright © 2019 Rohan Vasavada. All rights reserved.
//

import UIKit

class RVBadgeViewController: UIViewController {

	var textView = UITextView()
	
	var latitude = ""
	var longitude = ""
	
	let apiUrl = "https://api.hackillinois.org/event/"
	
	override func viewDidLoad() {
        super.viewDidLoad()
		parseJsonFromUrl(urlString: apiUrl)
		setupText()
    }
	
	func parseJsonFromUrl(urlString: String) {
		guard let url = URL(string: urlString) else {
			print("Oof, the url is invalid")
			return
		}
		
		let dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
			guard let jsonData = data, error == nil else {
				print("oof")
				return
			}
			
			let decoder = JSONDecoder()
			
			do {
				let eventList = try decoder.decode(EventList.self, from: jsonData)
				let event = self.getEventWithName(name: "Event 2", eventList: eventList)!
				
				self.longitude = event.locations[0].longitude.description
				self.latitude = event.locations[0].latitude.description
				
				DispatchQueue.main.async {
					self.textView.text = "Rohan Vasavada\nlongitude: \(self.longitude)\nlatitude: \(self.latitude)"
				}
			} catch let parsingError {
				print("oof", parsingError)
			}
		})
		
		dataTask.resume()
	}
	
	func setupText() {
		let frame = CGRect(x: 0, y: 450, width: self.view.frame.width, height: 200)
		textView = UITextView(frame: frame)
		
		textView.textAlignment = NSTextAlignment.center
		textView.font = UIFont(name: "HelveticaNeue-Light", size: 20)
		textView.textColor = UIColor.yellow
		textView.backgroundColor = UIColor.clear
		textView.text = "Loading..."
		
		view.addSubview(textView)
	}
	
	func getEventWithName(name: String, eventList: EventList) -> EventList.Event? {
		for event in eventList.events {
			if name == event.name {
				return event
			}
		}
		
		return nil
	}
}

struct EventList: Codable {
	var events: [Event]
	
	struct Event: Codable {
		var name: String
		var locations: [Location]
		
		struct Location: Codable {
			var latitude: Double
			var longitude: Double
		}
	}
}
