//
//  ShareLocationView.swift
//  ChatApp
//
//  Created by Sugandhi Hansika Kalansooriya on 2023-06-16.
//

import Foundation

import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI

struct ShareLocationView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 120), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
    @Binding var isShareLocationView : Bool
  
    @StateObject private var contentViewModel = ContentViewModl()
    
    var body: some View {
     
        
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $region, showsUserLocation: true)
                .ignoresSafeArea()
                .tint(.pink)
            LocationButton(.currentLocation) {
                contentViewModel.printLocationCoordinates()
                
               
            }
            .foregroundColor(.white)
            .cornerRadius(8)
            .labelStyle(.titleAndIcon)
            .symbolVariant(.fill)
            .tint(.pink)
            .padding(.bottom, 50)
            
            Button(action: {
                self.isShareLocationView = false
            }) {
             Text("Send Location")
            }
        }
        .onAppear {
            contentViewModel.requestAllowOnceLocationPermission()
        }
    }
}



final class ContentViewModl: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 120), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestAllowOnceLocationPermission() {
        locationManager.requestLocation()
    }
    
    func printLocationCoordinates() {
        if let latitude = locationManager.location?.coordinate.latitude,
           let longitude = locationManager.location?.coordinate.longitude {
            print("Latitude: \(latitude), Longitude: \(longitude)")
            let locationURLText = "maps://?q=\(latitude),\(longitude)"
           
            UserDefaults.standard.setValue(locationURLText, forKey: "location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {
            return
        }
        
        let latitude = latestLocation.coordinate.latitude
        let longitude = latestLocation.coordinate.longitude
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            print("Latitude: \(latitude), Longitude: \(longitude)") // Print the values to the console
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
