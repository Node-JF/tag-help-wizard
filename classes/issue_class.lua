Issue = {
    currentStage = 1
}

function Issue:nextStage()
    self.currentStage = self.currentStage + 1
    return self
end

function Issue:executeStage(stage)
    GStore.progressTimer:Stop()

    if (not self.stages[self.currentStage]) then return self:unResolved() end

    if Controls[string.format("issue.%d.stage.%d.skip", self.index, self.currentStage)].Boolean or
        Controls[string.format("issue.%d.stage.%d.message", self.index, self.currentStage)].String == "" or
        Controls[string.format("issue.%d.stage.%d.prompt.action", self.index, self.currentStage)].String == "" or
        Controls[string.format("issue.%d.stage.%d.prompt.resolution", self.index, self.currentStage)].String == "" then
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
    setMessage(stage.message)

    local logicInput = Controls[string.format("issue.%d.stage.%d.logicinput", self.index, self.currentStage)].Boolean

    GStore.actionTimer:Stop()

    if logicInput == true then

        GStore.actionTimer.EventHandler = function(t)
            t:Stop()
            setPrompt(stage.actionPrompt)
            local imageData = getImageByName(stage.image)
            setImage(imageData)
            Controls[string.format("issue.%d.stage.%d.action.trigger", self.index, self.currentStage)]:Trigger()

            if stage.confirmationDelay > 0 then -- create utility function and reference GStore progressTimer correctly

                local fps = 60
                GStore.progressTimer.EventHandler = function(t)
                    local currentPosition = Controls["wizard.controls.progress.stage"].Position
                    local increment = ((1 / fps) / stage.confirmationDelay)
                    setProgress(currentPosition + increment)
                    if currentPosition >= 1 then
                        t:Stop()
                        disableControls(false)
                        print("Waiting for User Confirmation...")
                        print("!! [Progress Timer Complete]")
                        return
                    end
                end

                print('!! [Starting Progress Timer]')
                GStore.progressTimer:Start((1 / fps))
            else
                disableControls(false)
            end
        end

    else

        GStore.actionTimer.EventHandler = function(t)
            t:Stop()
            setPrompt(stage.resolutionPrompt)
            Timer.CallAfter(function()
                self:nextStage()
                self:executeStage(self.stages[self.currentStage])
                print("Auto-Executing Next Stage")
            end, 1) -- needs to be a custom delay, disappears before user can read the resolution message.
        end

    end

    GStore.actionTimer:Start(stage.actionDelay)

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
    print(string.format('Issue Resolved at Stage [%d]', self.currentStage))
    setMessage(Controls["wizard.config.message.resolved"].String)
    disableControls(true)
    setPrompt()
    setImage()
    setProgress()
end

function Issue:unResolved()
    print(string.format('Issue Unresolved at Stage [%d]', self.currentStage - 1))
    setMessage(Controls["wizard.config.message.unresolved"].String)
    disableControls(true)
    setPrompt()
    setImage()
    setProgress()
end

function Issue:new(o)
    o = o or {} -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end
