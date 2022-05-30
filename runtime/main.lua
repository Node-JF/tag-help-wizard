GStore = {
    issues = {},
    progressTimer = Timer.New(),
    actionTimer = Timer.New(),
    userConfirmationTimer = Timer.New(),
    images = {},
    sharedStages = {}
}

function initialize()
    disableControls(true)
    setPrompt()
    setImage()
    setProgress()
    setMessage()
    setRunning()
    setDefaultCustomMessages()
    GStore.progressTimer:Stop()
    GStore.actionTimer:Stop()
    GStore.userConfirmationTimer:Stop()
    compileImageStore()
    compileSharedStages()
    getIssueList()
    resetIssueType()
end

function compileImageStore()
    GStore.images = {}
    for i = 1, Properties["Image Store Size"].Value do
        local imageName = Controls[string.format("store.image.%d.name", i)].String
        local imageData = Controls[string.format("store.image.%d.data", i)].String
        addImageToStore(imageName, imageData)
    end
    print("[Image Store Compiled]")
    -- print(string.format("Image Store:\n\n%s", rapidjson.encode(GStore.images, {
    --     pretty = true
    -- })))
    setImageChoices()
end

function compileSharedStages()
    GStore.sharedStages = {}
    for stage = 1, Properties["Total Stages"].Value do
        local stageName = Controls[string.format("shared.stage.%d.name", stage)].String
        addSharedStageToStore(stageName)
    end
    -- print("[Shared Stages Compiled]")
    print(string.format("Shared Stages:\n\n%s", rapidjson.encode(GStore.sharedStages, {
        pretty = true
    })))
    setStageChoices()
end

function setImageChoices()
    local imageChoices = getImageChoices()

    for stage = 1, Properties["Total Stages"].Value do
        Controls[string.format("shared.stage.%d.image", stage)].Choices = imageChoices
        if Controls[string.format("shared.stage.%d.image", stage)].String == "" then
            Controls[string.format("shared.stage.%d.image", stage)].String = imageChoices[1]
        end
    end

    validateImageChoices()
end

function setStageChoices()
    local sharedStageChoices = getSharedStageChoices()

    for issue = 1, Properties["Total Issues"].Value do
        for stage = 1, Properties["Stages per Issue"].Value do
            Controls[string.format("issue.%d.stage.%d.useshared", issue, stage)].Choices = sharedStageChoices
            if Controls[string.format("issue.%d.stage.%d.useshared", issue, stage)].String == "" then
                Controls[string.format("issue.%d.stage.%d.useshared", issue, stage)].String = sharedStageChoices[1]
            end
        end
    end

    validateStageChoices()
end

function validateImageChoices()
    for stage = 1, Properties["Total Stages"].Value do
        local imageName = Controls[string.format("shared.stage.%d.image", stage)].String
        Controls[string.format("shared.stage.%d.image", stage)].Color = getImageByName(imageName) and "" or "Red"
    end
end

function validateStageChoices()
    for issue = 1, Properties["Total Issues"].Value do
        for stage = 1, Properties["Stages per Issue"].Value do
            local stageControl = Controls[string.format("issue.%d.stage.%d.useshared", issue, stage)]
            stageControl.Color = getStageByName(stageControl.String) and "" or "Red"
        end
    end
end

function getIssueList()
    resetIssueList()
    for issue = 1, Properties["Total Issues"].Value do

        if Controls[string.format("issue.%d.enable", issue)].Boolean then
            addIssueToStore(issue)
        else
            print(string.format("!! Issue [%d] is not Enabled", issue))
        end

    end
    -- print("[Issues Compiled]")
    print(string.format("Issues:\n\n%s", rapidjson.encode(GStore.issues, {
        pretty = true
    })))
end

function getStageIndexByName(thisName)
    for index, name in ipairs(GStore.sharedStages) do
        if name == thisName then return index end
    end
    return false
end