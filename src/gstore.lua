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
    ["Status"] = {width - 30, (control_depth * 2) + (control_gap * 1)},
    ["LED"] = {16, control_depth},
    ["ListBox"] = {width - 30, (control_depth * 6) + (control_gap * 5)},
    ["Image"] = {width - 30, (control_depth * 6) + (control_gap * 5)}
}

Master_Object = {{

    ["PageName"] = "Wizard",

    ["Groupings"] = {{
        ["Name"] = "Global Configuration",
        ["Depth"] = 3,
        ["Controls"] = {{
            Name = "wizard_config_message_resolved",
            PrettyName = "Wizard~Configuration~Resolved Message",
            Label = "Resolved",
            ControlType = "Text",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 1
        }, {
            Name = "wizard_config_message_unresolved",
            PrettyName = "Wizard~Configuration~Unresolved Message",
            Label = "Unresolved",
            ControlType = "Text",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Text,
            GridPos = 2
        }, {
            Name = "wizard_config_delay_auto",
            PrettyName = "Wizard~Configuration~Auto Advance Delay",
            Label = "Delay (Auto-Advance)",
            ControlType = "Knob",
            ControlUnit = "Integer",
            Min = 1,
            Max = 10,
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 3
        }}

    }, {
        ["Name"] = "Controls",
        ["Depth"] = 28,
        ["Controls"] = {{
            Name = "wizard_controls_reset",
            PrettyName = "Wizard~Controls~Reset",
            Label = "Reset",
            ControlType = "Button",
            ButtonType = "Trigger",
            PinStyle = "Both",
            UserPin = true,
            Icon = "Refresh",
            Size = Sizes.Button,
            GridPos = 1
        },{
            Name = "wizard_controls_issue_type",
            PrettyName = "Wizard~Controls~Issue Type",
            Label = "Issue Type",
            ControlType = "Text",
            PinStyle = "Output",
            UserPin = true,
            Style = "ComboBox",
            Size = Sizes.Text,
            GridPos = 3
        }, {
            Name = "wizard_controls_issue_list",
            PrettyName = "Wizard~Controls~Issue List",
            Label = "Issue List",
            ControlType = "Text",
            PinStyle = "Output",
            UserPin = true,
            Style = "ListBox",
            Width = "Full",
            Size = Sizes.ListBox,
            GridPos = 4
        }, {
            Name = "wizard_controls_start",
            PrettyName = "Wizard~Controls~Start",
            Legend = "Start",
            ControlType = "Button",
            ButtonType = "Trigger",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 11
        }, {
            Name = "wizard_controls_message",
            PrettyName = "Wizard~Controls~User Message",
            Label = "Message",
            ControlType = "Indicator",
            IndicatorType = "Text",
            PinStyle = "Output",
            UserPin = true,
            Size = Sizes.Status,
            Width = "Full",
            GridPos = 12
        }, {
            Name = "wizard_controls_prompt",
            PrettyName = "Wizard~Controls~User Prompt",
            Label = "Prompt",
            ControlType = "Indicator",
            IndicatorType = "Text",
            PinStyle = "Output",
            UserPin = true,
            Size = Sizes.Status,
            Width = "Full",
            GridPos = 15
        }, {
            Name = "wizard_controls_image",
            Label = "Image",
            ControlType = "Button",
            ButtonType = "Toggle",
            Size = Sizes.Image,
            Width = "Full",
            GridPos = 18
        }, {
            Name = "wizard_controls_progress_stage",
            PrettyName = "Wizard~Controls~Stage Progress",
            Label = "Progress",
            ControlType = "Knob",
            ControlUnit = "Percent",
            Min = 0,
            Max = 100,
            PinStyle = "Output",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 26
        }, {
            Name = "wizard_controls_stage_next",
            PrettyName = "Wizard~Controls~Next Stage",
            Label = "Next Stage",
            Icon = "Fast Forward",
            ControlType = "Button",
            ButtonType = "Trigger",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 27
        }, {
            Name = "wizard_controls_issue_resolved",
            PrettyName = "Wizard~Controls~Issue Resolved",
            Label = "Issue Resolved",
            Icon = "Check",
            ControlType = "Button",
            ButtonType = "Trigger",
            PinStyle = "Both",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 28
        }}
    }, {
        ["Name"] = "Events",
        ["Depth"] = 3,
        ["Controls"] = {{
            Name = "wizard_events_isrunning",
            PrettyName = "Wizard~Events~Is Running",
            Label = "Wizard Is Running",
            ControlType = "Indicator",
            IndicatorType = "Led",
            PinStyle = "Output",
            UserPin = true,
            Size = Sizes.LED,
            GridPos = 1
        }, {
            Name = "wizard_events_trigger_resolved",
            PrettyName = "Wizard~Events~Issue Resolved Trigger",
            Label = "Issue Resolved Trigger",
            ControlType = "Button",
            ButtonType = "Trigger",
            PinStyle = "Output",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 2
        }, {
            Name = "wizard_events_trigger_unresolved",
            PrettyName = "Wizard~Events~Issue Unresolved Trigger",
            Label = "Issue Unresolved Trigger",
            ControlType = "Button",
            ButtonType = "Trigger",
            PinStyle = "Output",
            UserPin = true,
            Size = Sizes.Button,
            GridPos = 3
        }}
    }}
}, {

    ["PageName"] = "Image Store",

    ["Groupings"] = {}
},{

    ["PageName"] = "Shared Stages",

    ["Groupings"] = {}
}}
