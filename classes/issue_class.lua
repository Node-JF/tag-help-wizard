Issue = {
    currentStage = 1
}

function Issue:skipStage()
    self:nextStage()
    self:executeStage(self.stages[self.currentStage])
    disableControls(true)
end

function Issue:nextStage()
    self.currentStage = self.currentStage + 1
    return self
end

function Issue:executeStage(stage)
    GStore.progressTimer:Stop()
    GStore.userConfirmationTimer:Stop()

    if (not self.stages[self.currentStage]) then return self:unResolved() end

    setRunning(true)

    local stageIndex = getStageIndexByName(stage.name)

    if not stageIndex then
        print(string.format("!! Cannot Find Stage Index for [%s]", stage.name))
        self:skipStage()
        return
    end

    local stageControls = {
        message = Controls[string.format("shared.stage.%d.message", stageIndex)],
        actionPrompt = Controls[string.format("shared.stage.%d.prompt.action", stageIndex)],
        resolutionPrompt = Controls[string.format("shared.stage.%d.prompt.resolution", stageIndex)],
        image = Controls[string.format("shared.stage.%d.image", stageIndex)],
        -- actionDelay = Controls[string.format("shared.stage.%d.delay.action", stageIndex)],
        confirmationDelay = Controls[string.format("shared.stage.%d.delay.confirmation", stageIndex)],
        logicInput = Controls[string.format("shared.stage.%d.logicinput", stageIndex)],
        actionTrigger = Controls[string.format("shared.stage.%d.action.trigger", stageIndex)],
    }

    -- get shared stage if not 'None'
    -- local sharedStage = Controls[string.format("issue.%d.stage.%d.useshared", self.index, self.currentStage)]
    -- stage = replaceStageWithSharedStage(stage)

    if stageControls.message.String == "" or
    stageControls.actionPrompt.String == "" or
    stageControls.resolutionPrompt.String == "" then
        print(string.format("Skipping Stage [%d] - Could not Validate", self.currentStage))
        self:skipStage()
        return
    end

    print(string.format("Executing Stage [%d]", self.currentStage))

    disableControls(true)
    setPrompt()
    setImage()
    setProgress()
    setMessage(stageControls.message.String)

    GStore.actionTimer:Stop()

    if stageControls.logicInput.Boolean == true then

        GStore.actionTimer.EventHandler = function(t)
            t:Stop()
            setPrompt(stageControls.actionPrompt.String)
            local imageData = getImageByName(stageControls.image.String)
            setImage(imageData)
            stageControls.actionTrigger:Trigger()
            
            GStore.userConfirmationTimer.EventHandler = function(t)
                t:Stop()
                print("!! [Wizard Timed Out]")
                initialize()
            end

            if stageControls.confirmationDelay.Value > 0 then

                local fps = 60
                GStore.progressTimer.EventHandler = function(t)
                    local currentPosition = Controls["wizard.controls.progress.stage"].Position
                    local increment = ((1 / fps) / stageControls.confirmationDelay.Value)
                    setProgress(currentPosition + increment)

                    if stageControls.logicInput.Boolean == false then
                        t:Stop()
                        setProgress(1)
                        disableControls(false)
                        GStore.userConfirmationTimer:Start(Properties['Confirmation Timeout'].Value)
                        print("!! [Logic Indicates Issue if Fixed - Setting Progress to Complete]")
                        print("Waiting for User Confirmation...")
                        return
                    end

                    if currentPosition >= 1 then
                        t:Stop()
                        disableControls(false)
                        GStore.userConfirmationTimer:Start(Properties['Confirmation Timeout'].Value)
                        print("!! [Progress Timer Complete]")
                        print("Waiting for User Confirmation...")
                        return
                    end
                end

                print('!! [Starting Progress Timer]')
                GStore.progressTimer:Start((1 / fps))
            else
                disableControls(false)
                GStore.userConfirmationTimer:Start(Properties['Confirmation Timeout'].Value)
            end
        end

    else

        GStore.actionTimer.EventHandler = function(t)
            t:Stop()
            setPrompt(stageControls.resolutionPrompt.String)
            Timer.CallAfter(function()
                self:nextStage()
                self:executeStage(self.stages[self.currentStage])
                print("Auto-Executing Next Stage")
            end, Controls["wizard.config.delay.auto"].Value)
        end

    end

    GStore.actionTimer:Start(Controls[string.format("issue.%d.delay.action", self.index)].Value)

    Controls["wizard.controls.stage.next"].EventHandler = function()
        self:nextStage()
        self:executeStage(self.stages[self.currentStage])
        disableControls(true)
    end

    Controls["wizard.controls.issue.resolved"].EventHandler = function()
        self:resolved()
        disableControls(true)
    end
end

function Issue:resolved()
    GStore.progressTimer:Stop()
    GStore.userConfirmationTimer:Stop()
    print(string.format('Issue Resolved at Stage [%d]', self.currentStage))
    setMessage(Controls["wizard.config.message.resolved"].String)
    disableControls(true)
    setPrompt()
    setImage()
    setProgress()
    Controls["wizard.events.trigger.resolved"]:Trigger()
    Timer.CallAfter(function() setRunning(false) end, 3)
end

function Issue:unResolved()
    print(string.format('Issue Unresolved at Stage [%d]', self.currentStage - 1))
    setMessage(Controls["wizard.config.message.unresolved"].String)
    disableControls(true)
    setPrompt()
    setImage()
    setProgress()
    Controls["wizard.events.trigger.unresolved"]:Trigger()
    Timer.CallAfter(function() setRunning(false) end, 3)
end

function Issue:new(o)
    o = o or {} -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end
