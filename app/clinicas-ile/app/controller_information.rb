class ControllerInformation
  
  PROPERTIES = [
    :tag,
    :controllerClass,
    :title,
    :tabBarImage
  ]
  
  
  PROPERTIES.each { |prop| attr_accessor prop }
  
  def initialize(properties = {})
    properties.each { |key, value|
      self.send("#{key}=", value) if properties.member? key.to_sym
    }
  end
  
end