local master = {}

for i, tbl in ipairs(Master_Object) do
    table.insert(master, tbl)
end

if props["Use Shared Stages"].Value == "Yes" then
    table.insert(master, {

        ["PageName"] = "Shared Stages",
    
        ["Groupings"] = {}
    })
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

if props["Use Shared Stages"].Value == "Yes" then
    for stage = 1, props['Number of Shared Stages'].Value do
        table.insert(master[3].Groupings, {
            ["Name"] = string.format("Shared Stage %d", stage),
            ["Depth"] = 8,
            ["Controls"] = {{
                Name = string.format("shared.stage.%d.message", stage),
                PrettyName = string.format("Shared Stages~%d~Message", stage),
                Label = "Message",
                ControlType = "Text",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Text,
                GridPos = 1
            }, {
                Name = string.format("shared.stage.%d.prompt.action", stage),
                PrettyName = string.format("Shared Stages~%d~Action Prompt", stage),
                Label = "Action Prompt",
                ControlType = "Text",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Text,
                GridPos = 2
            }, {
                Name = string.format("shared.stage.%d.prompt.resolution", stage),
                PrettyName = string.format("Shared Stages~%d~Resolution Prompt", stage),
                Label = "Resolution Prompt",
                ControlType = "Text",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Text,
                GridPos = 3
            }, {
                Name = string.format("shared.stage.%d.image", stage),
                PrettyName = string.format("Shared Stages~%d~Image", stage),
                Label = "Image",
                ControlType = "Text",
                Style = "ComboBox",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Text,
                GridPos = 4
            }, {
                Name = string.format("shared.stage.%d.delay.action", stage),
                PrettyName = string.format("Shared Stages~%d~Action Delay", stage),
                Label = "Delay Between Steps",
                ControlType = "Knob",
                ControlUnit = "Integer",
                Min = 1,
                Max = 10,
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Button,
                GridPos = 5
            }, {
                Name = string.format("shared.stage.%d.delay.confirmation", stage),
                PrettyName = string.format("Shared Stages~%d~Confirmation Delay", stage),
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
                Name = string.format("shared.stage.%d.logicinput", stage),
                PrettyName = string.format("Shared Stages~%d~Logic Input", stage),
                ControlType = "Button",
                ButtonType = "Toggle",
                PinStyle = "Input",
                Label = "Logic Input",
                UserPin = true,
                Size = Sizes.Button,
                GridPos = 7
            }, {
                Name = string.format("shared.stage.%d.action.trigger", stage),
                PrettyName = string.format("Shared Stages~%d~Action Trigger", stage),
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
            ["Depth"] = 10,
            ["Controls"] = {{
                Name = string.format("issue.%d.stage.%d.useshared", i, stage),
                PrettyName = string.format("Issue %d~Stage %d~Use Shared Stage", i, stage),
                Label = "Use Shared Stage",
                ControlType = "Text",
                Style = "ComboBox",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Text,
                GridPos = 1
            },{
                Name = string.format("issue.%d.stage.%d.skip", i, stage),
                PrettyName = string.format("Issue %d~Stage %d~Skip Stage", i, stage),
                ControlType = "Button",
                ButtonType = "Toggle",
                PinStyle = "Output",
                Label = "Manually Skip this Stage",
                Legend = "Skip",
                UserPin = true,
                Size = Sizes.Button,
                GridPos = 2
            }, {
                Name = string.format("issue.%d.stage.%d.message", i, stage),
                PrettyName = string.format("Issue %d~Stage %d~Message", i, stage),
                Label = "Message",
                ControlType = "Text",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Text,
                GridPos = 3
            }, {
                Name = string.format("issue.%d.stage.%d.prompt.action", i, stage),
                PrettyName = string.format("Issue %d~Stage %d~Action Prompt", i, stage),
                Label = "Action Prompt",
                ControlType = "Text",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Text,
                GridPos = 4
            }, {
                Name = string.format("issue.%d.stage.%d.prompt.resolution", i, stage),
                PrettyName = string.format("Issue %d~Stage %d~Resolution Prompt", i, stage),
                Label = "Resolution Prompt",
                ControlType = "Text",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Text,
                GridPos = 5
            }, {
                Name = string.format("issue.%d.stage.%d.image", i, stage),
                PrettyName = string.format("Issue %d~Stage %d~Image", i, stage),
                Label = "Image",
                ControlType = "Text",
                Style = "ComboBox",
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Text,
                GridPos = 6
            }, {
                Name = string.format("issue.%d.stage.%d.delay.action", i, stage),
                PrettyName = string.format("Issue %d~Stage %d~Action Delay", i, stage),
                Label = "Delay Between Steps",
                ControlType = "Knob",
                ControlUnit = "Integer",
                Min = 1,
                Max = 10,
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Button,
                GridPos = 7
            }, {
                Name = string.format("issue.%d.stage.%d.delay.confirmation", i, stage),
                PrettyName = string.format("Issue %d~Stage %d~Confirmation Delay", i, stage),
                Label = "Wait Time",
                ControlType = "Knob",
                ControlUnit = "Integer",
                Min = 0,
                Max = 60,
                PinStyle = "Both",
                UserPin = true,
                Size = Sizes.Button,
                GridPos = 8
            }, {
                Name = string.format("issue.%d.stage.%d.logicinput", i, stage),
                PrettyName = string.format("Issue %d~Stage %d~Logic Input", i, stage),
                ControlType = "Button",
                ButtonType = "Toggle",
                PinStyle = "Input",
                Label = "Logic Input",
                UserPin = true,
                Size = Sizes.Button,
                GridPos = 9
            }, {
                Name = string.format("issue.%d.stage.%d.action.trigger", i, stage),
                PrettyName = string.format("Issue %d~Stage %d~Action Trigger", i, stage),
                ControlType = "Button",
                ButtonType = "Trigger",
                PinStyle = "Output",
                Label = "Action Trigger",
                UserPin = true,
                Size = Sizes.Button,
                GridPos = 10
            }}
        })
    end

    table.insert(master, tbl)
end
