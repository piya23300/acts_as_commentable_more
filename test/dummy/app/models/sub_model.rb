class SubModel < MainModel
  self.table_name = self.base_class.table_name
  def self.base_class
    self
  end
  
  acts_as_commentable
  
end
