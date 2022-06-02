function disableControls(bool)
    Controls["wizard_controls_stage_next"].IsDisabled = bool
    Controls["wizard_controls_issue_resolved"].IsDisabled = bool
end

function setImage(data)
    local data = data or ""
    Controls["wizard_controls_image"].Legend = rapidjson.encode({
        DrawChrome = false,
        IconData = data
    })
end

function setDefaultCustomMessages()
    if Controls["wizard_config_message_resolved"].String == "" then
        Controls["wizard_config_message_resolved"].String = "Great! Have a nice day."
    end
    if Controls["wizard_config_message_unresolved"].String == "" then
        Controls["wizard_config_message_unresolved"].String = "This issue could not be resolved. Please call technical support."
    end
end

function setMessage(message)
    local message = message or ""
    Controls["wizard_controls_message"].String = message
end

function setPrompt(prompt)
    local prompt = prompt or ""
    Controls["wizard_controls_prompt"].String = prompt
end

function setProgress(value)
    local value = value or 0
    Controls["wizard_controls_progress_stage"].Position = value
end

function setRunning(state)
    local state = state or false
    Controls["wizard_events_isrunning"].Boolean = state
end

function setCategoryChoices()
    local choices = {}
    for category, list in pairs(GStore.issues) do table.insert(choices, category) end
    Controls["wizard_controls_issue_type"].Choices = choices
end

function compileIssuesList()
    local choices = {}
    for i, item in ipairs(GStore.issues[Controls["wizard_controls_issue_type"].String]) do
        table.insert(choices, {
            Text = item.description,
            index = i
        })
    end
    Controls["wizard_controls_issue_list"].Choices = choices
end

function resetIssueType()
    Controls["wizard_controls_issue_type"].String = "Select an Issue Type..."
    setCategoryChoices()
end

function resetIssueList()
    Controls["wizard_controls_issue_list"].Choices = {}
    Controls["wizard_controls_issue_list"].String = ""
    GStore.issues = {}
end

function addImageToStore(imageName, imageData)
    if imageName == "" or imageData == "" then return end
    table.insert(GStore.images, {
        name = imageName,
        data = imageData
    })
end

function addSharedStageToStore(stageName)
    if stageName == ""  or stageName == "None" then return end
    table.insert(GStore.sharedStages, stageName)
end

function getImageChoices()
    local choices = {"None"}
    for i, tbl in ipairs(GStore.images) do
        table.insert(choices, tbl.name)
    end
    return choices
end

function getSharedStageChoices()
    local choices = {"None"}
    for i, name in ipairs(GStore.sharedStages) do
        table.insert(choices, name)
    end
    return choices
end

function getImageByName(imageName)
    for i, tbl in ipairs(GStore.images) do
        if imageName == tbl.name then return tbl.data end
    end
    if imageName == "None" or imageName == "" then return "" end
end

function getStageByName(stageName)
    for i, name in ipairs(GStore.sharedStages) do
        if stageName == name then return true end
    end
    if stageName == "None" or stageName == "" then return "" end
end

function addIssueToStore(issue)
    local category = Controls[string.format("issue_%d_category", issue)].String
    local description = Controls[string.format("issue_%d_description", issue)].String

    if category == "" then return end
    if description == "" then return end

    local stages = {}
    for stage = 1, Properties["Stages per Issue"].Value do

        GStore.issues[category] = GStore.issues[category] or {}

        table.insert(stages, {
            name = Controls[string.format("issue_%d_stage_%d_useshared", issue, stage)].String
        })

    end

    table.insert(GStore.issues[category], Issue:new({
        description = description,
        category = category,
        index = issue,
        stages = stages
    }))
end