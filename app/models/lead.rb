class Lead < ActiveRecord::Base

def price
	case self.car_type
	when "2-Door"
		return "59"
	when "4-Door"
		return "59"
	when "Minivan"
		return "79"
	when "SUV"
		return "79"
	when "Truck"
		return "79"
	when nil
		return "59"
	end 
end 	


end
