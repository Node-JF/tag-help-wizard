local master = {}

for i, tbl in ipairs(Master_Object) do
    table.insert(master, tbl)
end


for i = 1, props['Image Store Size'].Value do
    table.insert(master[2].Groupings, {
        ["Name"] = string.format("Image %d", i),
        ["Depth"] = 2,
        ["Controls"] = {{
            Name = string.format("store.image.%d.name", i),
            PrettyName = string.format("Image Store~%d~Name", i),
            Label = "Name",
            ControlType = "Text",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 1
        },{
          Name = string.format("store.image.%d.data", i),
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
        ["Depth"] = 9,
        ["Controls"] = {{
            Name = string.format("shared.stage.%d.name", stage),
            PrettyName = string.format("Shared Stages~Name~%d", stage),
            Label = "Name",
            ControlType = "Text",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 1
        }, {
            Name = string.format("shared.stage.%d.message", stage),
            PrettyName = string.format("Shared Stages~Message~%d", stage),
            Label = "Message",
            ControlType = "Text",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 2
        }, {
            Name = string.format("shared.stage.%d.prompt.action", stage),
            PrettyName = string.format("Shared Stages~Action Prompt~%d", stage),
            Label = "Action Prompt",
            ControlType = "Text",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 3
        }, {
            Name = string.format("shared.stage.%d.prompt.resolution", stage),
            PrettyName = string.format("Shared Stages~Resolution Prompt~%d", stage),
            Label = "Resolution Prompt",
            ControlType = "Text",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 4
        }, {
            Name = string.format("shared.stage.%d.image", stage),
            PrettyName = string.format("Shared Stages~Image~%d", stage),
            Label = "Image",
            ControlType = "Text",
            Style = "ComboBox",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 5
        }, {
            Name = string.format("shared.stage.%d.delay.action", stage),
            PrettyName = string.format("Shared Stages~Action Delay~%d", stage),
            Label = "Delay Between Steps",
            ControlType = "Knob",
            ControlUnit = "Integer",
            Min = 1,
            Max = 10,
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 6
        }, {
            Name = string.format("shared.stage.%d.delay.confirmation", stage),
            PrettyName = string.format("Shared Stages~Confirmation Delay~%d", stage),
            Label = "Wait Time",
            ControlType = "Knob",
            ControlUnit = "Integer",
            Min = 0,
            Max = 60,
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 7
        }, {
            Name = string.format("shared.stage.%d.logicinput", stage),
            PrettyName = string.format("Shared Stages~Logic Input~%d", stage),
            ControlType = "Button",
            ButtonType = "Toggle",
            PinStyle = "Input",
            Label = "Logic Input",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 8
        }, {
            Name = string.format("shared.stage.%d.action.trigger", stage),
            PrettyName = string.format("Shared Stages~Action Trigger~%d", stage),
            ControlType = "Button",
            ButtonType = "Trigger",
            PinStyle = "Output",
            Label = "Action Trigger",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 9
        }}
    })
end

for i = 1, props['Total Issues'].Value do

    local tbl = {
        ["PageName"] = string.format("Issue %d", i),

        ["Groupings"] = {{
            ["Name"] = "Configuration",
            ["Depth"] = 3,
            ["Controls"] = {{
                Name = string.format("issue.%d.enable", i),
                PrettyName = string.format("Issue %d~Enable", i),
                Label = "Enable",
                ControlType = "Button",
                ButtonType = "Toggle",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Button,
                GridPos = 1
            }, {
                Name = string.format("issue.%d.category", i),
                PrettyName = string.format("Issue %d~Category", i),
                Label = "Issue Category",
                ControlType = "Text",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Text,
                GridPos = 2
            }, {
                Name = string.format("issue.%d.description", i),
                PrettyName = string.format("Issue %d~Description", i),
                Label = "Description",
                ControlType = "Text",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Text,
                GridPos = 3
            }}
        }}
    }

    local controls = {}
    for stage = 1, props['Total Stages'].Value do

        table.insert(controls, {
                Name = string.format("issue.%d.stage.%d.useshared", i, stage),
                PrettyName = string.format("Issue %d~Use Shared Stage~%d", i, stage),
                Label = string.format("Stage %d", stage),
                ControlType = "Text",
                Style = "ComboBox",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Text,
                Position = (width-15) - Sizes.Text[1] - Sizes.Button[1],
                GridPos = stage
            })
            
            table.insert(controls, {
                Name = string.format("issue.%d.stage.%d.skip", i, stage),
                PrettyName = string.format("Issue %d~Skip Stage~%d", i, stage),
                ControlType = "Button",
                ButtonType = "Toggle",
                PinStyle = "Output",
                Legend = "Skip",
                UserPin = true,
                Size = Sizes.Button,
                GridPos = stage
            })

    end

    table.insert(tbl.Groupings, {
        ["Name"] = "Stages",
        ["Depth"] = props['Total Stages'].Value,
        ["Controls"] = controls
    })

    table.insert(master, tbl)
end
