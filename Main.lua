local UIS = game:GetService("UserInputService")
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
if UIS.KeyboardEnabled == false then
	for _, v in pairs(script.Parent:GetDescendants()) do
		if v.Name == "NumberKey" then
			v.Visible = false
		end
	end
end

local Player = game.Players.LocalPlayer
local Backpack = Player.Backpack
local Character = Player.Character

local CustomInventoryGui = script.Parent
local SlotsFrame = CustomInventoryGui.ItemSlots
local ChangeToolParents = CustomInventoryGui.ChangeToolParents

local CurrentSelectedSpot

local NumberAbbreviations = {
	
	{"One", "1"},
	{"Two", "2"},
	{"Three", "3"},
	{"Four", "4"},
	{"Five", "5"}
	
}


local function SetItems(Child, IsFromCharacter)
	
	if Child:IsA("Tool") then
		
		local ShouldReplace = true

		for _, v in pairs(SlotsFrame:GetChildren()) do
			if v:IsA("TextButton") then
				local ToolInstance = v:FindFirstChild("ToolInstance")
				if ToolInstance then
					if ToolInstance.Value == Child then
						ShouldReplace = false
					end
				end
			end
		end
		
		local FoundSpot = false
		
		if ShouldReplace == true then
			
			if IsFromCharacter == true then

				for _, v in pairs(SlotsFrame:GetChildren()) do

					local S, E = pcall(function()
					--	v.BorderMode = Enum.BorderMode.Outline
					--	v.BorderSizePixel = 3
						if v:FindFirstChild("SelectedItemStroke") then
							v.SelectedItemStroke:Destroy()
						end
						if v.ToolInstance.Value ~= nil then
							ChangeToolParents:FireServer(v.ToolInstance.Value, Backpack)
						end
					end)

				end
				
			else
				
				

			end
			
			for i, slot in pairs(SlotsFrame:GetChildren()) do
				if slot:IsA("TextButton") then
					if IsFromCharacter == true then
						if slot.ToolInstance.Value == nil then
							if FoundSpot == false then
								FoundSpot = true
								slot.ToolInstance.Value = Child
								slot.Text = Child.Name
								if Child.TextureId ~= nil then
									slot.ToolImageTexture.Image = Child.TextureId
									slot.ToolImageTexture.Visible = true
								--	slot.BorderMode = Enum.BorderMode.Inset
								--	slot.BorderSizePixel = 5
								--	local SelectedStroke = Instance.new("UIStroke", slot)
								--	SelectedStroke.Name = "SelectedItemStroke"
								--	SelectedStroke.Color = Color3.fromRGB(255, 255, 255)
								end

							end
						end
					else
						if slot.ToolInstance.Value == nil then
							if FoundSpot == false then
								FoundSpot = true
								slot.ToolInstance.Value = Child
								slot.Text = Child.Name
								if Child.TextureId ~= nil then
									slot.ToolImageTexture.Image = Child.TextureId
									slot.ToolImageTexture.Visible = true
								--	slot.BorderMode = Enum.BorderMode.Outline
								--	slot.BorderSizePixel = 3
								end

							end
						end
					end
				end
			end
			
		end

	end
	
end

local function RemoveItem(Child)
	for i, slot in pairs(SlotsFrame:GetChildren()) do
		if slot:IsA("TextButton") then
			if slot.ToolInstance.Value == Child then
				
				local ShouldDelete = true
				
				for i, Tool in pairs(Backpack:GetChildren()) do
					if Tool:IsA("Tool") then
						if Tool == slot.ToolInstance.Value then
							ShouldDelete = false
						end
					end
				end
				
				if ShouldDelete == true then
					
					slot.Text = ""
					slot.ToolImageTexture.Visible = false
					slot.ToolImageTexture.Image = ""
					
					slot.ToolInstanceValue.Value = nil	
					
				end
				
			end
		end
	end
end

UIS.InputBegan:Connect(function(InputObject, Typing)
	if Typing == false then
		
		local JustEquippedTool = false
		
		local Number
		
		for _, v in pairs(NumberAbbreviations) do
			
			if v[1] == InputObject.KeyCode.Name then
				Number = v[2]
			end
			
		end
		
		
		
		if Number ~= nil then
			local Slot = SlotsFrame:FindFirstChild("Slot"..Number)
			
			if Slot.ToolInstance.Value ~= nil and Slot.ToolInstance.Value.Parent == Character then
				local Slot = SlotsFrame:FindFirstChild("Slot"..Number)

				ChangeToolParents:FireServer(Slot.ToolInstance.Value, Backpack)

				if Slot and Slot.ToolInstance.Value ~= nil then


					local S, E = pcall(function()
					---	Slot.BorderMode = Enum.BorderMode.Outline
					---	Slot.BorderSizePixel = 3
						if Slot:FindFirstChild("SelectedItemStroke") then
							Slot.SelectedItemStroke:Destroy()
						end
					end)

				end

				local EquippedTool = Character:FindFirstChildOfClass("Tool")

				if EquippedTool then

					for _, v in pairs(SlotsFrame:GetChildren()) do
						if v:IsA("TextButton") then
							local ToolInstance = v:FindFirstChild("ToolInstance")
							if ToolInstance then
								if ToolInstance.Value == EquippedTool then
									ChangeToolParents:FireServer(EquippedTool, Backpack)

								--	v.BorderMode = Enum.BorderMode.Outline
								--	v.BorderSizePixel = 3
									if v:FindFirstChild("SelectedItemStroke") then
										v.SelectedItemStroke:Destroy()
									end
								end
							end
						end
					end

				end
			else
				if Slot and Slot.ToolInstance.Value ~= nil then

					CurrentSelectedSpot = tonumber(Number)

					for _, v in pairs(SlotsFrame:GetChildren()) do

						local S, E = pcall(function()
						--	v.BorderMode = Enum.BorderMode.Outline
						--	v.BorderSizePixel = 3
							if v:FindFirstChild("SelectedItemStroke") then
								v.SelectedItemStroke:Destroy()
							end
							if v.ToolInstance.Value ~= nil then
								ChangeToolParents:FireServer(v.ToolInstance.Value, Backpack)
							end
						end)

					end


					JustEquippedTool = true

					--Slot.BorderMode = Enum.BorderMode.Inset
					--Slot.BorderSizePixel = 5
					--local SelectedStroke = Instance.new("UIStroke", Slot)
					--SelectedStroke.Name = "SelectedItemStroke"
					--SelectedStroke.Color = Color3.fromRGB(255, 255, 255)

					ChangeToolParents:FireServer(Slot.ToolInstance.Value, Character)
				end
			end
		end
		
	end
end)

for _, startertool in pairs(Backpack:GetChildren()) do
	if startertool:IsA("Tool") then
		SetItems(startertool, false)
	end
end

Character.ChildAdded:Connect(function(Child)
	SetItems(Child, true)
end)
Backpack.ChildAdded:Connect(function(Child)
	SetItems(Child, false)
end)

Character.ChildRemoved:Connect(RemoveItem)

for _, v in pairs(SlotsFrame:GetChildren()) do
	
	if v:IsA("TextButton") then
			local Typing = false
			if Typing == false then

			v.MouseButton1Click:Connect(function()
				local JustEquippedTool = false

				local Number = nil

				Number = string.sub(v.Name, 5, 5)
				print(Number)

				if Number ~= nil then
					local Slot = SlotsFrame:FindFirstChild("Slot"..Number)

					if Slot.ToolInstance.Value ~= nil and Slot.ToolInstance.Value.Parent == Character then
						local Slot = SlotsFrame:FindFirstChild("Slot"..Number)

						ChangeToolParents:FireServer(Slot.ToolInstance.Value, Backpack)

						if Slot and Slot.ToolInstance.Value ~= nil then


							local S, E = pcall(function()
							--	Slot.BorderMode = Enum.BorderMode.Outline
							--	Slot.BorderSizePixel = 3
								if Slot:FindFirstChild("SelectedItemStroke") then
									Slot.SelectedItemStroke:Destroy()
								end
							end)

						end

						local EquippedTool = Character:FindFirstChildOfClass("Tool")

						if EquippedTool then

							for _, v in pairs(SlotsFrame:GetChildren()) do
								if v:IsA("TextButton") then
									local ToolInstance = v:FindFirstChild("ToolInstance")
									if ToolInstance then
										if ToolInstance.Value == EquippedTool then
											ChangeToolParents:FireServer(EquippedTool, Backpack)

										--	v.BorderMode = Enum.BorderMode.Outline
											--v.BorderSizePixel = 3
											if v:FindFirstChild("SelectedItemStroke") then
												v.SelectedItemStroke:Destroy()
											end
										end
									end
								end
							end

						end
					else
						if Slot and Slot.ToolInstance.Value ~= nil then

							CurrentSelectedSpot = tonumber(Number)

							for _, v in pairs(SlotsFrame:GetChildren()) do

								local S, E = pcall(function()
								--	v.BorderMode = Enum.BorderMode.Outline
								--	v.BorderSizePixel = 3
									if v:FindFirstChild("SelectedItemStroke") then
										v.SelectedItemStroke:Destroy()
									end
									if v.ToolInstance.Value ~= nil then
										ChangeToolParents:FireServer(v.ToolInstance.Value, Backpack)
									end
								end)

							end


							JustEquippedTool = true

						--	Slot.BorderMode = Enum.BorderMode.Inset
						--	Slot.BorderSizePixel = 5
						--	local SelectedStroke = Instance.new("UIStroke", Slot)
						--	SelectedStroke.Name = "SelectedItemStroke"
							--SelectedStroke.Color = Color3.fromRGB(255, 255, 255)

							ChangeToolParents:FireServer(Slot.ToolInstance.Value, Character)
						end
					end
				end
			end)

			end
		
	end
	
end
