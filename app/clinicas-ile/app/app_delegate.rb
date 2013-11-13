class AppDelegate
  
  
  
  def application(application, didFinishLaunchingWithOptions: launchOptions)
    
    controllersInformation = [
      ControllerInformation.new(tag: 1,controllerClass: ClinicsListController, title: 'Clinicas Registradas', tabBarImage: 'hospital-icon.png'),
      ControllerInformation.new(tag: 2,controllerClass: CommunityController, title: 'Comunidad', tabBarImage: 'Patients-icon.png')
    ]
    
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible
    
    tab_controller = UITabBarController.alloc.init
    tab_controller.viewControllers = loadAllControllers controllersInformation
    tab_controller.tabBar.tintColor = UIColor.colorWithRed( 255/100, green:0.0, blue:0.0, alpha:1.0)
    
    @window.rootViewController = tab_controller
    
    
    true
  end
  
  
  def loadAllControllers(controllersInformation)
    controllers = []
    
    controllersInformation.each { |c|
      controllers << controllerLoader(c)
    }
    
    controllers
  end
  
  
  
  def controllerLoader(controllerInformation)
    controller = controllerInformation.controllerClass.alloc.initWithNibName(nil, bundle: nil)
    controller.title = controllerInformation.title
    navigation = UINavigationController.alloc.initWithRootViewController  controller
    navigation.tabBarItem = UITabBarItem.alloc.initWithTitle(
        controllerInformation.title,
        image: UIImage.imageNamed(controllerInformation.tabBarImage), tag: controllerInformation.tag)
    navigation.navigationBar.tintColor = UIColor.redColor
    navigation
  end
end
