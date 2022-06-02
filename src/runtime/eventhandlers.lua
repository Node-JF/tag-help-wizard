for i = 1, Properties["Image Store Size"].Value do
  Controls[string.format("store_image_%d_name", i)].EventHandler = compileImageStore
  Controls[string.format("store_image_%d_data", i)].EventHandler = compileImageStore
end

for stage = 1, Properties["Total Stages"].Value do
  Controls[string.format("shared_stage_%d_name", stage)].EventHandler = compileSharedStages
  Controls[string.format("shared_stage_%d_image", stage)].EventHandler = validateImageChoices
end


for issue = 1, Properties["Total Issues"].Value do
  Controls[string.format("issue_%d_enable", issue)].EventHandler = initialize
  Controls[string.format("issue_%d_category", issue)].EventHandler = initialize
  Controls[string.format("issue_%d_description", issue)].EventHandler = initialize
  for stage = 1, Properties["Stages per Issue"].Value do
      Controls[string.format("issue_%d_stage_%d_useshared", issue, stage)].EventHandler = initialize
  end
end

Controls["wizard_config_message_resolved"].EventHandler = setDefaultCustomMessages
Controls["wizard_config_message_unresolved"].EventHandler = setDefaultCustomMessages
Controls["wizard_controls_reset"].EventHandler = initialize

Controls["wizard_controls_issue_type"].EventHandler = function(c)
  if (not GStore.issues[c.String]) then return print('!! [No Issue Type Found]') end
  Controls["wizard_controls_issue_list"].String = ""
  compileIssuesList()
end

Controls["wizard_controls_start"].EventHandler = function()
  local issue = rapidjson.decode(Controls["wizard_controls_issue_list"].String)
  if not issue then return print("!! No Issue Selected") end -- guard clause
  print(string.format("Starting Wizard: Selected Issue [%s]", Controls["wizard_controls_issue_list"].String))
  local issueIndex = issue.index
  local issueType = Controls["wizard_controls_issue_type"].String
  local issueObject = GStore.issues[issueType][issueIndex]
  issueObject.currentStage = 1
  issueObject:executeStage(issueObject.stages[issueObject.currentStage])
end