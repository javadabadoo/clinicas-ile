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

    labels = {
      'name' => UILabel.alloc.initWithFrame([[10, 170], [self.view.frame.size.width, 0]]),
      'address' => UILabel.alloc.initWithFrame([[10, 195], [self.view.frame.size.width, 100]])
    }


    buttons = {
      'rate' => UIButton.buttonWithType(UIButtonTypeRoundedRect),
      'comments' => UIButton.buttonWithType(UIButtonTypeRoundedRect)
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


      buttons['rate'].setTitle("Calificar", forState: UIControlStateNormal)
      buttons['comments'].setTitle("Comentarios", forState: UIControlStateNormal)
      buttons['rate'].sizeToFit
      buttons['comments'].sizeToFit

      buttons['rate'].frame = CGRect.new (
        [labels['name'].frame.origin.x, labels['address'].frame.origin.y + labels['address'].frame.size.height + 20],
        buttons['rate'].frame.size
      )

      buttons['comments'].frame = CGRect.new (
        [buttons['rate'].frame.origin.x + buttons['rate'].frame.size.width + 20, labels['address'].frame.origin.y + labels['address'].frame.size.height + 20],
        buttons['comments'].frame.size
      )


      self.view.addSubview(image)
      self.view.addSubview(buttons['rate'])
      self.view.addSubview(buttons['comments'])

        
    end
    
    self.view.addSubview(labels['name'])
    self.view.addSubview(labels['address'])
end

end