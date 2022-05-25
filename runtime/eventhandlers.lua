for i = 1, Properties["Image Store Size"].Value do
  Controls[string.format("store.image.%d.name", i)].EventHandler = compileImageStore
  Controls[string.format("store.image.%d.data", i)].EventHandler = compileImageStore
end

for issue = 1, Properties["Number of Issues"].Value do
  for stage = 1, Properties["Number of Stages"].Value do
      Controls[string.format("issue.%d.stage.%d.image", issue, stage)].EventHandler = validateImages
  end
end

Controls["wizard.config.message.resolved"].EventHandler = setDefaultCustomMessages
Controls["wizard.config.message.unresolved"].EventHandler = setDefaultCustomMessages
Controls["wizard.controls.compile"].EventHandler = initialize

Controls["wizard.controls.issue.type"].EventHandler = function(c)
  if (not GStore.issues[c.String]) then return print('!! [No Issue Type Found]') end
  Controls["wizard.controls.issue.list"].String = ""
  compileIssuesList()
end

Controls["wizard.controls.start"].EventHandler = function()
  local issue = rapidjson.decode(Controls["wizard.controls.issue.list"].String)
  if not issue then return print("!! No Issue Selected") end -- guard clause
  print(string.format("Starting Wizard: Selected Issue [%s]", Controls["wizard.controls.issue.list"].String))
  local issueIndex = issue.index
  local issueType = Controls["wizard.controls.issue.type"].String
  local issueObject = GStore.issues[issueType][issueIndex]
  issueObject.currentStage = 1
  issueObject:executeStage(issueObject.stages[issueObject.currentStage])
end