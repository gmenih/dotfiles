return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    keys = {
      "<leader>aj",
      "<cmd>CopilotChatFixCalendarTest<CR>", -- Fix stupid tests
      desc = "Fix calendar tests",
      mode = { "n", "v" },
    },
    opts = function(_, opts)
      opts.debug = true
      opts.prompts = {
        FixStupidTest = {
          prompt = "/COPILOT_GENERATE Convert this code to expect.arrayContaining and expect.objectContaining. Only output the code, no additional text",
          description = "Fix stupid tests",
          selection = require("CopilotChat.select").visual,
        },
        FixCalendarTest = {
          mapping = "<leader>aj",
          prompt = [=[
### Context
I have a large number of unit tests for a `CalendarBuilder` class in my TypeScript project. Recently, the data structure used by this class has changed. I need to update the unit tests to reflect this new structure.

### Old Code
Previously, I used two separate arrays (`ProgramInterval` and `FinishedActivity`) to pass data to the builder. I also used helper functions (`programInterval` and `finishedActivity`) to construct this data.

Here's an example of the old code:

```typescript
const calendar = new WorkoutCalendarBuilder(tz)
  .addActivityIntervals([
    finishedActivity('2024-02-01', { programId: 'program-1' }),
    finishedActivity('2024-02-02', { programId: 'program-1' }),
    finishedActivity('2024-02-03', { programId: 'program-1' }),
  ])
  .addProgramIntervals([
    programInterval('2024-02-01', { id: 'program-1', endDate: '2024-02-15', status: 'FINISHED' }),
  ])
```

### New Code
The new structure combines these into a single `ActivityInterval` array, using a new helper function `programActivity`. Here's how the new code looks:

```typescript
const calendar = new WorkoutCalendarBuilder(tz)
  .addActivityIntervals([
    programActivity({
      id: 'program-1',
      state: 'FINISHED',
      startDate: '2024-01-01',
      endDate: '2024-01-15',
      phases: [
        {
          workouts: [{ finishedAt: '2024-01-01' }, { finishedAt: '2024-01-02' }, { finishedAt: '2024-01-03' }],
        },
      ],
    }),
  ])
```

### Task
I need to update all instances in my unit tests where `finishedActivity` and `programInterval` are used, replacing them with the new `programActivity` structure.

### Helper Functions
- Old: `finishedActivity`, `programInterval`
- New: `programActivity`

### Expected Output
Update my unit tests to use the new `programActivity` structure, ensuring that all data previously passed in via `finishedActivity` and `programInterval` is correctly transformed into the new format. Only output code and no additional text.

          ]=],
          description = "Fix calendar tests",
          selection = require("CopilotChat.select").visual,
        },
      }
    end,
  },
}
