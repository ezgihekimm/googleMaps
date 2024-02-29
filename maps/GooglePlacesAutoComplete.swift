
import SwiftUI
import GoogleMaps
import GooglePlaces

struct GooglePlacesAutoComplete: UIViewControllerRepresentable {
    
    @Binding var input: String
    @Binding var selectedPlace: String
    
    class Coordinator: NSObject, GMSAutocompleteViewControllerDelegate {
        
        var parent: GooglePlacesAutoComplete
        
        init(parent: GooglePlacesAutoComplete) {
            self.parent = parent
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            parent.input = place.name ?? ""
            parent.selectedPlace = place.formattedAddress ?? ""
            viewController.dismiss(animated: true, completion: nil)
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("Error: \(error.localizedDescription)")
        }
        
        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    func makeUIViewController(context: Context) -> GMSAutocompleteViewController {
        let acController = GMSAutocompleteViewController()
        acController.delegate = context.coordinator
        return acController
    }
    
    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: Context) {
        // Update the view controller if needed
    }
}
