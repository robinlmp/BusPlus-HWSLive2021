//
//  MapView.swift
//  MapView
//
//  Created by Robin Phillips on 04/08/2021.
//

import SwiftUI
import MapKit


struct MapView: UIViewRepresentable {
    
    let searchString: String
    
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.canShowCallout = true
            return view
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            print(mapView.centerCoordinate)
        }
        
        init(_ parent: MapView) {
            self.parent = parent
        }
    }
    
    func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchString
        
        // Set the region to an associated map view's region.
        searchRequest.region = mapView.region
        
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                print(error?.localizedDescription ?? "unknown error")
                return
            }
            
            for item in response.mapItems {
                if let name = item.name,
                   let location = item.placemark.location {
                    print("\(name): \(location.coordinate.latitude),\(location.coordinate.longitude)")
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = "Bus Location"
                    annotation.subtitle = searchString
                    annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    mapView.addAnnotation(annotation)
                    
                    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    mapView.region = MKCoordinateRegion(center: center, span: span)
                }
                
            }
            
        }
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
