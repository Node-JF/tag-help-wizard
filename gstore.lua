width = 250 -- scalable plugin width
control_depth = 16 -- scalable control depth
control_gap = 3 -- vertical space between controls

Colors = {
    none = {0, 0, 0, 0},
    primary = {250, 218, 93},
    secondary = {236, 222, 243},
    heading = {50, 50, 50},
    label = {50, 50, 50},
    stroke = {119, 80, 169},
    black = {50, 50, 50}
}

Sizes = {
    ["Button"] = {36, control_depth},
    ["Text"] = {(width - 30) / 2, control_depth},
    ["Status"] = {width - 30, control_depth},
    ["LED"] = {16, control_depth},
    ["ListBox"] = {width - 30, (control_depth * 5) + (control_gap * 4)},
    ["Image"] = {width - 30, (control_depth * 6) + (control_gap * 5)}
}

Master_Object = {{

    ["PageName"] = "Wizard",

    ["Groupings"] = {{
        ["Name"] = "Custom Messages",
        ["Depth"] = 2,
        ["Controls"] = {{
            Name = "wizard.config.message.resolved",
            PrettyName = "Wizard~Configuration~Resolved Message",
            Label = "Resolved",
            ControlType = "Text",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 1
        }, {
            Name = "wizard.config.message.unresolved",
            PrettyName = "Wizard~Configuration~Unresolved Message",
            Label = "Unresolved",
            ControlType = "Text",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 2
        }}

    }, {
        ["Name"] = "Controls",
        ["Depth"] = 26,
        ["Controls"] = {{
            Name = "wizard.controls.issue.type",
            Label = "Issue Category",
            ControlType = "Text",
            Style = "ComboBox",
            Size = Sizes.Text,
            GridPos = 1
        }, {
            Name = "wizard.controls.issue.list",
            Label = "Issue List",
            ControlType = "Text",
            Style = "ListBox",
            Width = "Full",
            Size = Sizes.ListBox,
            GridPos = 3
        }, {
            Name = "wizard.controls.start",
            PrettyName = "Wizard~Controls~Start",
            Legend = "Start",
            ControlType = "Button",
            ButtonType = "Trigger",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 9
        }, {
            Name = "wizard.controls.message",
            PrettyName = "Wizard~Controls~User Message",
            Label = "Message",
            ControlType = "Indicator",
            IndicatorType = "Text",
            PinStyle = "Output",
            UserPin = true,
            Size = Sizes.Status,
            Width = "Full",
            GridPos = 10
        }, {
            Name = "wizard.controls.prompt",
            PrettyName = "Wizard~Controls~User Prompt",
            Label = "Prompt",
            ControlType = "Indicator",
            IndicatorType = "Text",
            PinStyle = "Output",
            UserPin = true,
            Size = Sizes.Status,
            Width = "Full",
            GridPos = 13
        }, {
            Name = "wizard.controls.image",
            Label = "Image",
            ControlType = "Button",
            ButtonType = "Toggle",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Image,
            Width = "Full",
            GridPos = 16
        }, {
            Name = "wizard.controls.progress",
            Label = "Progress",
            ControlType = "Knob",
            ControlUnit = "Position",
            PinStyle = "Output",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 24
        }, {
            Name = "wizard.controls.stage.next",
            PrettyName = "Wizard~Controls~Next Stage",
            Label = "Next Stage",
            Icon = "Fast Forward",
            ControlType = "Button",
            ButtonType = "Trigger",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 25
        }, {
            Name = "wizard.controls.issue.resolved",
            PrettyName = "Wizard~Controls~Issue Resolved",
            Label = "Issue Resolved",
            Icon = "Check",
            ControlType = "Button",
            ButtonType = "Trigger",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 26
        }}
    }}
}, {

    ["PageName"] = "Image Store",

    ["Groupings"] = {}
}}
