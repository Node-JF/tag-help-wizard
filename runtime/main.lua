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
    -- compileSharedStages()
    -- setSharedStageChoices()
    getIssues()
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
    setChoices()
end

function setChoices()
    local imageChoices = getImageChoices()
    local sharedStageChoices = getSharedStageChoices()

    for issue = 1, Properties["Number of Issues"].Value do
        for stage = 1, Properties["Number of Stages"].Value do
            Controls[string.format("issue.%d.stage.%d.image", issue, stage)].Choices = imageChoices
            if Controls[string.format("issue.%d.stage.%d.image", issue, stage)].String == "" then
                Controls[string.format("issue.%d.stage.%d.image", issue, stage)].String = imageChoices[1]
            end
            Controls[string.format("issue.%d.stage.%d.useshared", issue, stage)].Choices = sharedStageChoices
            if Controls[string.format("issue.%d.stage.%d.useshared", issue, stage)].String == "" then
                Controls[string.format("issue.%d.stage.%d.useshared", issue, stage)].String = sharedStageChoices[1]
            end
        end
    end

    for stage = 1, Properties["Number of Shared Stages"].Value do
        local imageName = Controls[string.format("shared.stage.%d.image", stage)].String
        Controls[string.format("shared.stage.%d.image", stage)].Choices = imageChoices
        if Controls[string.format("shared.stage.%d.image", stage)].String == "" then
            Controls[string.format("shared.stage.%d.image", stage)].String = imageChoices[1]
        end
    end

    validateChoices()
end

function validateChoices()
    for issue = 1, Properties["Number of Issues"].Value do
        for stage = 1, Properties["Number of Stages"].Value do
            local imageName = Controls[string.format("issue.%d.stage.%d.image", issue, stage)].String
            Controls[string.format("issue.%d.stage.%d.image", issue, stage)].Color =
                getImageByName(imageName) and "" or "Red"

            local sharedStageString = Controls[string.format("issue.%d.stage.%d.useshared", issue, stage)].String
            if sharedStageString == "None" then
                Controls[string.format("issue.%d.stage.%d.useshared", issue, stage)].Color = ""
            else
                sharedStageString = rapidjson.decode(sharedStageString)
                local sharedStageId = sharedStageString.index
                local sharedStageControl = Controls[string.format("shared.stage.%d.message", sharedStageId)]
                Controls[string.format("issue.%d.stage.%d.useshared", issue, stage)].Color = sharedStageControl and "" or "Red"
            end
            
        end
    end

    for stage = 1, Properties["Number of Shared Stages"].Value do
        local imageName = Controls[string.format("shared.stage.%d.image", stage)].String
        Controls[string.format("shared.stage.%d.image", stage)].Color = getImageByName(imageName) and "" or "Red"
    end
end

function getIssues()
    resetIssueList()
    for issue = 1, Properties["Number of Issues"].Value do

        if Controls[string.format("issue.%d.enable", issue)].Boolean then

            local issueCategory = Controls[string.format("issue.%d.category", issue)].String
            GStore.issues[issueCategory] = GStore.issues[issueCategory] or {}

            local stages = {}
            for stage = 1, Properties["Number of Stages"].Value do

                table.insert(stages, {
                    skip = Controls[string.format("issue.%d.stage.%d.skip", issue, stage)],
                    useShared = Controls[string.format("issue.%d.stage.%d.useshared", issue, stage)],
                    message = Controls[string.format("issue.%d.stage.%d.message", issue, stage)],
                    actionPrompt = Controls[string.format("issue.%d.stage.%d.prompt.action", issue, stage)],
                    resolutionPrompt = Controls[string.format("issue.%d.stage.%d.prompt.resolution", issue, stage)],
                    confirmationDelay = Controls[string.format("issue.%d.stage.%d.delay.confirmation", issue, stage)],
                    actionDelay = Controls[string.format("issue.%d.stage.%d.delay.action", issue, stage)],
                    image = Controls[string.format("issue.%d.stage.%d.image", issue, stage)],
                    logicInput = Controls[string.format("issue.%d.stage.%d.logicinput", issue, stage)],
                    actionTrigger = Controls[string.format("issue.%d.stage.%d.action.trigger", issue, stage)]
                })
            end

            addIssueToStore(Controls[string.format("issue.%d.description", issue)].String,
                Controls[string.format("issue.%d.category", issue)].String, issue, stages)

        else
            print(string.format("!! Issue [%d] is not Enabled", issue))
        end

    end
    print("[Issues Compiled]")
    -- print(string.format("Issues:\n\n%s", rapidjson.encode(GStore.issues, {
    --     pretty = true
    -- })))
end

function replaceStageWithSharedStage(stage)
    if stage.useShared.String ~= "None" then
        local sharedStage = rapidjson.decode(stage.useShared.String).index

        if not Controls[string.format("shared.stage.%s.message", sharedStage)] then
            print("!! [Shared Stage not Valid - Cannot Replace Current Stage with Shared Stage]")
            return stage
        end

        print(string.format("!! Using Shared Stage [%d] Instead", sharedStage))
        stage = {
            skip = stage.skip,
            message = Controls[string.format("shared.stage.%s.message", sharedStage)],
            actionPrompt = Controls[string.format("shared.stage.%s.prompt.action", sharedStage)],
            resolutionPrompt = Controls[string.format("shared.stage.%s.prompt.resolution", sharedStage)],
            logicInput = Controls[string.format("shared.stage.%s.logicinput", sharedStage)],
            actionTrigger = Controls[string.format("shared.stage.%s.action.trigger", sharedStage)],
            image = Controls[string.format("shared.stage.%s.image", sharedStage)],
            actionDelay = Controls[string.format("shared.stage.%s.delay.action", sharedStage)],
            confirmationDelay = Controls[string.format("shared.stage.%s.delay.confirmation", sharedStage)]
        }
    end
    return stage
end

