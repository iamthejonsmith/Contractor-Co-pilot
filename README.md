# Contractor-Co-pilot
Contractor Co-pilot Final

Contractor Co-pilot is a helper app for on the road contractors working long-term contracts
This app gets the current location for the contractor based on phone GPS

The user is presented with a list of possible vendors to choose from, including one for a custom vendor search.
The vendors are commonly used vendors that are searched for upon moving to a new location.

Once the user chooses a vendor type, the app will auto-locate all vendors of that type using the yellowAPI provided by Yellow Pages.

The user will then be presented with a list of all vendors matching that search description

From this point, there are two options: choosing the navigation arrow on the toolbar will present a map view with the
locations from the list pinned and selectable for gps coordinates. 

The second option is to click on a list item (cell) and it will present the user a contact information page for the vendor which
which provides, the vendor name, address and telephone number. If the vendor has listed their full address, it will be 
clickable which will provide automatic gps services provided by apple maps.

Written with xcode 5
Supports older versions of iPhone back to iPhone 4
Uses yellowAPI (YellowPages)
Uses NSURLSession for data retrieval
Data is retrieved from yellowAPI as JSon OBject and decoded using NSJsonSerialization methods
Graphics were created and implemented by Jonathan Smith using Gimp 2
Coding performed by Jonathan Smith
Map Functions assisted by CoreLocation Framework
Core Data Stack is included for scalability

Future releases/updates will include language selection for foreign language support and saving location. 
Color scheme selections may be included in future releases
