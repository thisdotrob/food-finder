module CurrencyFormatter

	def to_dollar_s(number,dps=0)
		case dps
			when 0 then sprintf('$%.0f', number)
			when 1 then sprintf('$%.1f', number)
			else sprintf('$%.2f', number)
		end
		
	end

end
