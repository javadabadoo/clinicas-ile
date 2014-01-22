class ClinicDetailController < UIViewController


  attr_accessor :data
  attr_accessor :server_url



  def initialize (data, server_url)
  	@data = data
  	@server_url = server_url
  end



  def viewDidLoad
  	self.view.backgroundColor = UIColor.whiteColor
    self.title = "Detalle: #{@data[0].to_s}"

    scrollView = UIScrollView.alloc.initWithFrame(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 1.3)

    rightButton = UIBarButtonItem.alloc.initWithTitle(
        "Comentarios",
        style: UIBarButtonItemStyleDone,
        target: self,
        action: 'show_comments'
    )

    self.navigationItem.rightBarButtonItem = rightButton;

    self.view.addSubview(scrollView)

    labels = {
      'name' => UILabel.alloc.initWithFrame([[10, 170], [self.view.frame.size.width, 0]]),
      'address' => UILabel.alloc.initWithFrame([[10, 195], [self.view.frame.size.width, 100]])
    }


    labels['name'].textColor = UIColor.blackColor
    labels['address'].textColor = UIColor.grayColor


    labels.each { |label, value|
      value.lineBreakMode = UILineBreakModeWordWrap
      value.numberOfLines = 0
      value.textAlignment = NSTextAlignmentLeft
    }

    BubbleWrap::HTTP.get("#{@server_url}/ile-clinics.json") do |response|
      json =  BubbleWrap::JSON.parse(response.body.to_s)

      clinic_information =  json['clinic'][@data[1].to_i - 1]

      image_url =  clinic_information['picture'].nil? ? "#{@server_url}#{clinic_information['picture']}" :  "http://www.profem.com.mx/images/slideHome.jpg"

      data = NSData.dataWithContentsOfURL(NSURL.URLWithString(image_url))
      image = UIImageView.alloc.initWithFrame([[0, 0], [320, 150]])
      image.contentMode = UIViewContentModeScaleAspectFit
      image.image = UIImage.imageWithData(data)

      labels['name'].text = clinic_information['name']
      labels['address'].text = clinic_information['address']

      labels['name'].sizeToFit

      rate_view = JDDRateViewController.alloc.initWithFrame([[10, 390], [32 * 5, 32]])
      rate_view.backgroundColor = UIColor.clearColor
      rate_view.delegate = self
      
      scrollView.addSubview(image)
      scrollView.addSubview(rate_view)

        
    end
    
    scrollView.addSubview(labels['name'])
    scrollView.addSubview(labels['address'])
  end




  def jdd_rating_clicked(star_tapped)
    p "calificando con #{star_tapped} estrellas"
  end



  def show_comments
    controller = JDDCommentsViewController.new
    self.navigationController.pushViewController(controller, animated: true)
    controller
  end

end