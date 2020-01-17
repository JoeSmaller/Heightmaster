-- Basic Rodux Component
-- Joe (ITBV)
-- January 9, 2020



local function join(original, children)
	local newTable = {}
	if (original) then
		for i,v in pairs(original) do
			newTable[i] = v
		end
	end
	if (children) then
		for i,v in pairs(children) do
			newTable[i] = v
		end
	end
	return newTable
end

return function(Roact, RoactRodux)
	local BasicRoduxComponent = Roact.PureComponent:extend("BasicRoduxComponent")

	function BasicRoduxComponent:render()
		local props = self.props

		return Roact.createElement("Frame", {
			AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5);
			BackgroundColor3 = Color3.new(1, 1, 1);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			Position = props.Position or UDim2.new(0.5, 0, 0.5, 0);
			Size = props.Size or UDim2.new(1, 0, 1, 0);
		}, join(props[Roact.Children], {
			
		}))
	end

	return RoactRodux.connect(
		-- state properties
		function(state, props)
			return {
				value = 1;
			}
		end,
		-- state actions
		function(dispatch)
			return {
				valueAction = {
					type = "valueAction";
				}
			}
		end
	)(BasicRoduxComponent)
end