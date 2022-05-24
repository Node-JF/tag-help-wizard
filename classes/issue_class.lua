Issue = {
    currentStage = 1
}

function Issue:nextStage()
    self.currentStage = self.currentStage + 1
    return self
end

function Issue:executeStage(stage)
    progressTimer:Stop()
    if (not self.stages[self.currentStage]) then
        return self:unResolved()
    end
    print(string.format("Executing Stage [%d]", self.currentStage))

    clear()

    Controls.Message.String = stage.message

    -- subscribe to the callback
    if (callback) then
        Notifications.Unsubscribe(callback)
    end
    callback = Notifications.Subscribe(
        string.format("au.com.tag.helpmatrix.callback.%s.%s", self.category, self.number), function(name, data)
            print(string.format("Notification [%s]; Requesting Action [%s]; Wait Time [%d]", name, data.requiresAction,
                data.wait))

            -- setImage("")

            local actionTimer = Timer.New()
            if data.requiresAction == true then
                actionTimer.EventHandler = function(t)
                    t:Stop()
                    Controls.Prompt.String = data.prompt
                    setImage(stage.image)
                    disableControls(false)
                    Notifications.Publish(string.format("au.com.tag.helpmatrix.logicaction.%s.%s", self.category,
                        self.number), {
                        stage = self.currentStage
                    })
                    print("Waiting for User Confirmation...")
                    if data.wait > 0 then
                        print('!! [Starting Progress Timer]')
                        progressTimer.EventHandler = function(t)

                            increment = ((1 / fps) / data.wait)
                            Controls.Progress.Position = Controls.Progress.Position + increment
                            if Controls.Progress.Position >= 1 then
                                t:Stop()
                                return print("!! [Progress Timer Complete]");
                            end
                        end
                        progressTimer:Start((1 / fps))
                    end
                end
            else
                actionTimer.EventHandler = function(t)
                    t:Stop()
                    Controls.Prompt.String = data.prompt
                    Timer.CallAfter(function()
                        self:nextStage()
                        self:executeStage(self.stages[self.currentStage])
                        print("Auto-Executing Next Stage")
                    end, 1)
                end
            end
            actionTimer:Start(1)
        end)

    Controls["Next Stage"].EventHandler = function()
        self:nextStage()
        self:executeStage(self.stages[self.currentStage])
        disableControls(true)
    end

    Controls["Issue Resolved"].EventHandler = function()
        self:resolved()
        disableControls(true)
    end
end

function Issue:resolved()
    progressTimer:Stop()
    print(string.format('Issue Resolved at Stage [%d]', self.currentStage))
    Controls.Message.String = Controls['Resolved Message'].String
    clear()
end

function Issue:unResolved()
    print(string.format('Issue Unresolved at Stage [%d]', self.currentStage - 1))
    Controls.Message.String = Controls['Unresolved Message'].String
    clear()
end

function Issue:new(o)
    o = o or {} -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end
