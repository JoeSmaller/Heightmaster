-- New Plugin
-- Joe (ITBV)
-- December 31, 2019



-- Services
local Studio = settings().Studio

-- Libraries
local Libraries = script.Parent:WaitForChild("Libraries")
local Roact = require(Libraries:WaitForChild("Roact"))
local Rodux = require(Libraries:WaitForChild("Rodux"))
local RoactRodux = require(Libraries:WaitForChild("RoactRodux"))
local Reducer = require(Libraries:WaitForChild("Reducer"))
local StateMiddleware = require(Libraries:WaitForChild("StateMiddleware"))

-- Variables
local plugin = plugin
local Store
local Toolbar

-- Constants
local PLUGIN_NAME = "NewPlugin"
local TOOLBAR_NAME = "New Plugin"
local ELEMENTS = {
	NEWPLUGIN = {
		ENABLED = true;
		GUI_ENABLED = true;
		BUTTON_ID = "NewPluginButton";
		BUTTON_TOOLTIP = "A brand new plugin";
		BUTTON_ICON = "";
		BUTTON_TITLE = "New Plugin";
		BUTTON_FUNCTION = nil;
		GUI_ID = "NewPluginGui";
		GUI_TITLE = "New Plugin";
		GUI_DOCKWIDGETINFO = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 300, 300);
		GUI_APP = require(Libraries:WaitForChild("PluginApp"));
	}
}



--// Code //--

Store = Rodux.Store.new(Reducer(Rodux), nil, StateMiddleware)

plugin.Name = PLUGIN_NAME
Toolbar = plugin:CreateToolbar(TOOLBAR_NAME)


-- Create elements
local function createElement(element)
	
	if (element.ENABLED) then
		local elementButton = Toolbar:CreateButton(element.BUTTON_ID, element.BUTTON_TOOLTIP, element.BUTTON_ICON, element.BUTTON_TITLE)

		-- Create gui instead of having a single button
		if (element.GUI_ENABLED) then
			assert(element.GUI_APP, "Roact gui must be provided for element")
			
			local elementGui = plugin:CreateDockWidgetPluginGui(element.GUI_ID, element.GUI_DOCKWIDGETINFO)
			elementGui.Title = element.GUI_TITLE

			local elementApp = Roact.mount(element.GUI_APP(Store, Roact, RoactRodux), elementGui)

			-- functions
			local function setPluginActive(bool)
				elementGui.Enabled = bool
				elementButton:SetActive(bool)
			end

			elementButton.Click:Connect(function()
				setPluginActive(not elementGui.Enabled)
			end)

			elementGui:GetPropertyChangedSignal("Enabled"):Connect(function()
				if (elementGui.Enabled == false) then
					setPluginActive(false)
				end
			end)

			Studio.ThemeChanged:Connect(function()
				Roact.unmount(elementApp)
				elementApp = Roact.mount(element.GUI_APP(Store, Roact, RoactRodux), elementGui)
			end)
		elseif (not element.GUI_ENABLED) then
			assert(type(element.BUTTON_FUNCTION) == "function", "Button Function must be provided")
			elementButton.Click:Connect(function()
				element.BUTTON_FUNCTION()
			end)
		end
	end
end


for _,element in pairs(ELEMENTS) do
	createElement(element)
end