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

for i = 1, props['Number of Issues'].Value do

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

    for stage = 1, props['Number of Stages'].Value do
        table.insert(tbl.Groupings, {
            ["Name"] = string.format("Stage %d", stage),
            ["Depth"] = 7,
            ["Controls"] = {{
                Name = string.format("issue.%d.stage.%d.message", i, stage),
                PrettyName = string.format("Issue %d~Stage %d~Message", i, stage),
                Label = "Message",
                ControlType = "Text",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Text,
                GridPos = 1
            }, {
                Name = string.format("issue.%d.stage.%d.prompt.action", i, stage),
                PrettyName = string.format("Issue %d~Stage %d~Action Prompt", i, stage),
                Label = "Action Prompt",
                ControlType = "Text",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Text,
                GridPos = 2
            }, {
                Name = string.format("issue.%d.stage.%d.prompt.resolution", i, stage),
                PrettyName = string.format("Issue %d~Stage %d~Resolution Prompt", i, stage),
                Label = "Resolution Prompt",
                ControlType = "Text",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Text,
                GridPos = 3
            }, {
                Name = string.format("issue.%d.stage.%d.image", i, stage),
                PrettyName = string.format("Issue %d~Stage %d~Image", i, stage),
                Label = "Image",
                ControlType = "Text",
                Style = "ComboBox",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Text,
                GridPos = 4
            }, {
                Name = string.format("issue.%d.stage.%d.wait", i, stage),
                PrettyName = string.format("Issue %d~Stage %d~Wait Time", i, stage),
                Label = "Wait Time",
                ControlType = "Knob",
                ControlUnit = "Integer",
                Min = 0,
                Max = 60,
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Button,
                GridPos = 5
            }, {
                Name = string.format("issue.%d.stage.%d.logicinput", i, stage),
                PrettyName = string.format("Issue %d~Stage %d~Logic Input", i, stage),
                -- Label = "Description",
                ControlType = "Indicator",
                IndicatorType = "Led",
                PinStyle = "Input",
                Label = "Logic Input",
                UserPin = true,
                Size = Sizes.LED,
                GridPos = 6
            }, {
                Name = string.format("issue.%d.stage.%d.action.trigger", i, stage),
                PrettyName = string.format("Issue %d~Stage %d~Action Trigger", i, stage),
                -- Label = "Description",
                ControlType = "Button",
                ButtonType = "Trigger",
                PinStyle = "Output",
                Label = "Action Trigger",
                UserPin = true,
                Size = Sizes.Button,
                GridPos = 7
            }}
        })
    end

    table.insert(master, tbl)
end
