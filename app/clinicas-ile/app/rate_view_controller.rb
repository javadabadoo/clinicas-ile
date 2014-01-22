class JDDRateViewController < UIView

  @star_image_size
  @star_items

  attr_writer :delegate


  def init
    @star_image_size = 32
  end



  def initWithFrame(frame)
      super
      self
  end


  
  def drawRect(rect)
    init

    tap_gesture_recognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action: 'rate_tap:')
    self.addGestureRecognizer(tap_gesture_recognizer)

    addRateComponent
  end



  def addRateComponent
    stars =  [CALayer.layer, CALayer.layer, CALayer.layer, CALayer.layer, CALayer.layer]
    x = 0

    stars.each do |star|
      star.frame = [[x, 0], [@star_image_size, @star_image_size]]
      star_image = UIImage.imageNamed "star_silver"
      star.contents = star_image.CGImage
      self.layer.addSublayer(star)
      x += @star_image_size
    end
  end



  def rate_tap(tap_gesture_recognizer)
    tap_point_in_view = tap_gesture_recognizer.locationInView(self)
    star_tap_index = (tap_point_in_view.x / @star_image_size).floor
    

    (0 .. self.layer.sublayers.count - 1).each do |star_index|
      star_image = star_index <= star_tap_index ? "star_gold" : "star_silver"
      self.layer.sublayers[star_index].contents = UIImage.imageNamed(star_image).CGImage
    end

    unless ! @delegate.respond_to?("jdd_rating_clicked")
      @delegate.jdd_rating_clicked(star_tap_index + 1)
    end
  end

end