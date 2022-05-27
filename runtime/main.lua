GStore = {
    issues = {},
    progressTimer = Timer.New(),
    actionTimer = Timer.New(),
    userConfirmationTimer = Timer.New(),
    images = {}
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
    print(string.format("Image Store:\n\n%s", rapidjson.encode(GStore.images, {
        pretty = true
    })))
    setImageChoices()
end

function setImageChoices()
    local choices = getImageChoices()
    for issue = 1, Properties["Number of Issues"].Value do
        for stage = 1, Properties["Number of Stages"].Value do
            Controls[string.format("issue.%d.stage.%d.image", issue, stage)].Choices = choices
        end
    end
    validateImages()
end

function validateImages()
    for issue = 1, Properties["Number of Issues"].Value do
        for stage = 1, Properties["Number of Stages"].Value do
            local imageName = Controls[string.format("issue.%d.stage.%d.image", issue, stage)].String
            Controls[string.format("issue.%d.stage.%d.image", issue, stage)].Color = getImageByName(imageName) and "" or "Red"
        end
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
                    message = Controls[string.format("issue.%d.stage.%d.message", issue, stage)].String,
                    actionPrompt = Controls[string.format("issue.%d.stage.%d.prompt.action", issue, stage)].String,
                    resolutionPrompt = Controls[string.format("issue.%d.stage.%d.prompt.resolution", issue, stage)].String,
                    confirmationDelay = Controls[string.format("issue.%d.stage.%d.delay.confirmation", issue, stage)].Value,
                    actionDelay = Controls[string.format("issue.%d.stage.%d.delay.action", issue, stage)].Value,
                    image = Controls[string.format("issue.%d.stage.%d.image", issue, stage)].String
                })
            end

            addIssueToStore(
                Controls[string.format("issue.%d.description", issue)].String,
                Controls[string.format("issue.%d.category", issue)].String,
                issue,
                stages
            )

        else
            print(string.format("!! Issue [%d] is not Enabled", issue))
        end

    end

    print(string.format("Issues:\n\n%s", rapidjson.encode(GStore.issues, {
        pretty = true
    })))
end

