table.insert(props, {
  Name = "Image Store Size",
  Type = "integer",
  Min = 2,
  Max = 100,
  Value = 5
})

table.insert(props, {
  Name = "Number of Issues",
  Type = "integer",
  Min = 2,
  Max = 100,
  Value = 5
})

table.insert(props, {
  Name = "Number of Stages",
  Type = "integer",
  Min = 2,
  Max = 10,
  Value = 2
})

table.insert(props, {
  Name = "Use Shared Stages",
  Type = "enum",
  Choices = {"Yes", "No"},
  Value = "No"
})

table.insert(props, {
  Name = "Number of Shared Stages",
  Type = "integer",
  Min = 2,
  Max = 100,
  Value = 2
})

table.insert(props, {
  Name = "Confirmation Timeout",
  Type = "integer",
  Min = 15,
  Max = 120,
  Value = 60
})