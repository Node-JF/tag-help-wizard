Issue = {
    currentStage = 1
}

function Issue:nextStage()
    self.currentStage = self.currentStage + 1
    return self
end

function Issue:executeStage(stage)
    GStore.progressTimer:Stop()
    GStore.userConfirmationTimer:Stop()
    setRunning(true)

    if (not self.stages[self.currentStage]) then return self:unResolved() end


    -- get shared stage if not 'None'
    -- local sharedStage = Controls[string.format("issue.%d.stage.%d.useshared", self.index, self.currentStage)]
    stage = replaceStageWithSharedStage(stage)

    if stage.skip.Boolean or
    stage.message.String == "" or
    stage.actionPrompt.String == "" or
    stage.resolutionPrompt.String == "" then
        print(string.format("Skipping Stage [%d] - Configure Text Fields or Turn off 'Skip' Mode", self.currentStage))
        self:nextStage()
        self:executeStage(self.stages[self.currentStage])
        disableControls(true)
        return
    end

    print(string.format("Executing Stage [%d]", self.currentStage))

    disableControls(true)
    setPrompt()
    setImage()
    setProgress()
    setMessage(stage.message.String)

    -- local logicInput = stage.logicInput

    GStore.actionTimer:Stop()

    if stage.logicInput.Boolean == true then

        GStore.actionTimer.EventHandler = function(t)
            t:Stop()
            setPrompt(stage.actionPrompt.String)
            local imageData = getImageByName(stage.image.String)
            setImage(imageData)
            stage.actionTrigger:Trigger()
            
            GStore.userConfirmationTimer.EventHandler = function(t)
                t:Stop()
                print("!! [Wizard Timed Out]")
                initialize()
            end

            if stage.confirmationDelay.Value > 0 then -- create utility function and reference GStore progressTimer correctly

                local fps = 60
                GStore.progressTimer.EventHandler = function(t)
                    local currentPosition = Controls["wizard.controls.progress.stage"].Position
                    local increment = ((1 / fps) / stage.confirmationDelay.Value)
                    setProgress(currentPosition + increment)

                    if stage.logicInput.Boolean == false then
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
            setPrompt(stage.resolutionPrompt.String)
            Timer.CallAfter(function()
                self:nextStage()
                self:executeStage(self.stages[self.currentStage])
                print("Auto-Executing Next Stage")
            end, 1) -- needs to be a custom delay, disappears before user can read the resolution message.
        end

    end

    GStore.actionTimer:Start(stage.actionDelay.Value)

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
