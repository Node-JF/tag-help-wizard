local master = {}

for i, tbl in ipairs(Master_Object) do
    table.insert(master, tbl)
end


for i = 1, props['Image Store Size'].Value do
    table.insert(master[2].Groupings, {
        ["Name"] = string.format("Image %d", i),
        ["Depth"] = 2,
        ["Controls"] = {{
            Name = string.format("store_image_%d_name", i),
            PrettyName = string.format("Image Store~%d~Name", i),
            Label = "Name",
            ControlType = "Text",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 1
        },{
          Name = string.format("store_image_%d_data", i),
          PrettyName = string.format("Image Store~%d~Data", i),
          Label = "Base64 Image Data",
          ControlType = "Text",
          PinStyle = "Both",
          UserPin = true,
          Size = Sizes.Text,
          GridPos = 2
      }}
    })
end

for stage = 1, props['Total Stages'].Value do
    table.insert(master[3].Groupings, {
        ["Name"] = string.format("Shared Stage %d", stage),
        ["Depth"] = 8,
        ["Controls"] = {{
            Name = string.format("shared_stage_%d_name", stage),
            PrettyName = string.format("Shared Stages~Name~%d", stage),
            Label = "Name",
            ControlType = "Text",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 1
        }, {
            Name = string.format("shared_stage_%d_message", stage),
            PrettyName = string.format("Shared Stages~Message~%d", stage),
            Label = "Message",
            ControlType = "Text",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 2
        }, {
            Name = string.format("shared_stage_%d_prompt_action", stage),
            PrettyName = string.format("Shared Stages~Action Prompt~%d", stage),
            Label = "Action Prompt",
            ControlType = "Text",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 3
        }, {
            Name = string.format("shared_stage_%d_prompt_resolution", stage),
            PrettyName = string.format("Shared Stages~Resolution Prompt~%d", stage),
            Label = "Resolution Prompt",
            ControlType = "Text",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 4
        }, {
            Name = string.format("shared_stage_%d_image", stage),
            PrettyName = string.format("Shared Stages~Image~%d", stage),
            Label = "Image",
            ControlType = "Text",
            Style = "ComboBox",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 5
        }, {
            Name = string.format("shared_stage_%d_delay_confirmation", stage),
            PrettyName = string.format("Shared Stages~Confirmation Delay~%d", stage),
            Label = "Wait Time",
            ControlType = "Knob",
            ControlUnit = "Integer",
            Min = 0,
            Max = 60,
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 6
        }, {
            Name = string.format("shared_stage_%d_logicinput", stage),
            PrettyName = string.format("Shared Stages~Logic Input~%d", stage),
            ControlType = "Button",
            ButtonType = "Toggle",
            PinStyle = "Input",
            Label = "Logic Input",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 7
        }, {
            Name = string.format("shared_stage_%d_action_trigger", stage),
            PrettyName = string.format("Shared Stages~Action Trigger~%d", stage),
            ControlType = "Button",
            ButtonType = "Trigger",
            PinStyle = "Output",
            Label = "Action Trigger",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 8
        }}
    })
end

for i = 1, props['Total Issues'].Value do

    local tbl = {
        ["PageName"] = string.format("Issue %d", i),

        ["Groupings"] = {{
            ["Name"] = "Configuration",
            ["Depth"] = 4,
            ["Controls"] = {{
                Name = string.format("issue_%d_enable", i),
                PrettyName = string.format("Issue %d~Enable", i),
                Label = "Enable",
                ControlType = "Button",
                ButtonType = "Toggle",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Button,
                GridPos = 1
            }, {
                Name = string.format("issue_%d_category", i),
                PrettyName = string.format("Issue %d~Category", i),
                Label = "Issue Category",
                ControlType = "Text",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Text,
                GridPos = 2
            }, {
                Name = string.format("issue_%d_description", i),
                PrettyName = string.format("Issue %d~Description", i),
                Label = "Description",
                ControlType = "Text",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Text,
                GridPos = 3
            }, {
                Name = string.format("issue_%d_delay_action", i),
                PrettyName = string.format("Issue %d~Action Delay", i),
                Label = "Delay (Message -> Prompt)",
                ControlType = "Knob",
                ControlUnit = "Integer",
                Min = 1,
                Max = 10,
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Button,
                GridPos = 4
            }}
        }}
    }

    local controls = {}
    for stage = 1, props['Stages per Issue'].Value do

        table.insert(controls, {
                Name = string.format("issue_%d_stage_%d_useshared", i, stage),
                PrettyName = string.format("Issue %d~Use Shared Stage~%d", i, stage),
                Label = string.format("Stage %d", stage),
                ControlType = "Text",
                Style = "ComboBox",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Text,
                GridPos = stage
            })

    end

    table.insert(tbl.Groupings, {
        ["Name"] = "Stages",
        ["Depth"] = props['Stages per Issue'].Value,
        ["Controls"] = controls
    })

    table.insert(master, tbl)
end
