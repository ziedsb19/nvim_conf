return {
  {

    lazy = false,
    enabled = true,
    'rmagatti/auto-session',
    opts = {
      post_restore_cmds = {
        function()
          -- Force persistent-breakpoints to reload for active buffers
          require("persistent-breakpoints.api").load_breakpoints()
        end,
      },
    },
  }
}
