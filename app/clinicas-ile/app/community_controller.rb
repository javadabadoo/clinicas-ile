class JDDCommunityController < UIViewController
  
  
  def viewDidLoad
    view.backgroundColor = UIColor.blackColor
    alert = UIAlertView.alloc.initWithTitle(
    	"Wooops!",
    	message: "Not supported yet.",
    	delegate: nil,
    	cancelButtonTitle: "close",
    	otherButtonTitles: nil
    )

    alert.show
  end

end