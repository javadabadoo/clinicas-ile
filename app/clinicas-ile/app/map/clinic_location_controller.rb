class ClinicLocationViewController < UIViewController


  attr_accessor :event



  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.bounds)

  end



  def viewDidLoad
    super

    @location_label = UILabel.alloc.initWithFrame([[25,170], [290, 40]])
    @location_label.backgroundColor = UIColor.clearColor
    @location_label.font = UIFont.fontWithName('Helvetica', size:10.0)
    @map_view_for_event = mapViewForEvent

    @location_label.text = 'Esta es la ubicación'


    self.view.addSubview(@map_view_for_event)
    self.view.addSubview @location_label

    requestUserCurrentLocation

  end



  def viewDidUnload
    @location_manager.stopUpdatingLocation
    @location_manager.delegate = nil
  end




  #CLLocationManagerDelegate methods



  def viewMap
    @event_map_view_controller = EventMapViewController.alloc.init
    @event_map_view_controller.event = @event

    self.view.addSubview(@event_map_view_controller.view)
  end

  def mapViewForEvent
    map_view_for_event = MKMapView.alloc.initWithFrame( [[0, 0], [self.view.frame.size.width, self.view.frame.size.height]] )
    map_view_for_event.mapType = MKMapTypeStandard
    map_view_for_event.showsUserLocation = true

    map_view_for_event
  end


  def viewDidUnload
    super
    @location_manager.stopUpdatingLocation
    @location_manager.delegate = nil
    @event_date_label = nil
    @event_address_label = nil
    @first_talk_label = nil
    @second_talk_label = nil
    @location_label = nil
    @map_view_for_event = nil
  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    interfaceOrientation == UIInterfaceOrientationPortrait
  end



  def requestUserCurrentLocation
    if CLLocationManager.locationServicesEnabled
      @location_manager = CLLocationManager.alloc.init

      @location_manager.desiredAccuracy = KCLLocationAccuracyBest

      @location_manager.delegate = self

      @location_manager.purpose = 'Provide clinic location'
      @location_manager.startUpdatingLocation
    else
      showAlertWithTitle('Location error', 'Please enable the location services for this app in settings')
    end

  end




  def showAlertWithTitle(title, andMessage:message)
    alert_view = UIAlertView.alloc.initWithTitle( title,
                                                  message:message,
                                                  delegate:nil,
                                                  cancelButtonTitle:'Ok',
                                                  otherButtonTitles:nil )
    alert_view.show
  end



  def locationManager(manager, didUpdateToLocation:newLocation, fromLocation:oldLocation)
    @location_label.text = "Latitude:#{newLocation.coordinate.latitude} Longitude:#{newLocation.coordinate.longitude}"

    coordinates = CLLocationCoordinate2D.new(newLocation.coordinate.latitude,newLocation.coordinate.longitude)
    region      = MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(0.01, 0.01))

    @map_view_for_event.setRegion region
  end



  def locationManager(manager, didFailWithError:error)
    showAlertWithTitle('Error', andMessage: error.description)
  end


end