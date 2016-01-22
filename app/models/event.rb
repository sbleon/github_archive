class Event < ApplicationRecord
  self.inheritance_column = 'there_is_no_sti_here'
end
