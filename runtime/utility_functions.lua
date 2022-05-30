function disableControls(bool)
    Controls["wizard.controls.stage.next"].IsDisabled = bool
    Controls["wizard.controls.issue.resolved"].IsDisabled = bool
end

function setImage(data)
    local data = data or ""
    Controls["wizard.controls.image"].Legend = rapidjson.encode({
        DrawChrome = false,
        IconData = data
    })
end

function setDefaultCustomMessages()
    if Controls["wizard.config.message.resolved"].String == "" then
        Controls["wizard.config.message.resolved"].String = "Great! Have a nice day."
    end
    if Controls["wizard.config.message.unresolved"].String == "" then
        Controls["wizard.config.message.unresolved"].String = "This issue could not be resolved. Please call technical support."
    end
end

function setMessage(message)
    local message = message or ""
    Controls["wizard.controls.message"].String = message
end

function setPrompt(prompt)
    local prompt = prompt or ""
    Controls["wizard.controls.prompt"].String = prompt
end

function setProgress(value)
    local value = value or 0
    Controls["wizard.controls.progress.stage"].Position = value
end

function setRunning(state)
    local state = state or false
    Controls["wizard.events.isrunning"].Boolean = state
end

function setCategoryChoices()
    local choices = {}
    for category, list in pairs(GStore.issues) do table.insert(choices, category) end
    Controls["wizard.controls.issue.type"].Choices = choices
end

function compileIssuesList()
    local choices = {}
    for i, item in ipairs(GStore.issues[Controls["wizard.controls.issue.type"].String]) do
        table.insert(choices, {
            Text = item.description,
            index = i
        })
    end
    Controls["wizard.controls.issue.list"].Choices = choices
end

function resetIssueType()
    Controls["wizard.controls.issue.type"].String = "Select an Issue Type..."
    setCategoryChoices()
end

function resetIssueList()
    Controls["wizard.controls.issue.list"].Choices = {}
    Controls["wizard.controls.issue.list"].String = ""
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
    local category = Controls[string.format("issue.%d.category", issue)].String
    local description = Controls[string.format("issue.%d.description", issue)].String

    if category == "" then return end
    if description == "" then return end

    local stages = {}
    for stage = 1, Properties["Stages per Issue"].Value do

        GStore.issues[category] = GStore.issues[category] or {}

        table.insert(stages, {
            name = Controls[string.format("issue.%d.stage.%d.useshared", issue, stage)].String
        })

    end

    table.insert(GStore.issues[category], Issue:new({
        description = description,
        category = category,
        index = issue,
        stages = stages
    }))
end