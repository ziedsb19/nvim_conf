return {
    "igorlfs/nvim-dap-view",
    dependencies = {
        -- https://github.com/mfussenegger/nvim-dap
        'mfussenegger/nvim-dap',
        -- https://github.com/nvim-neotest/nvim-nio
        'nvim-neotest/nvim-nio',
        -- https://github.com/theHamsta/nvim-dap-virtual-text
        'theHamsta/nvim-dap-virtual-text',   -- inline variable text while debugging
        -- https://github.com/nvim-telescope/telescope-dap.nvim
        'nvim-telescope/telescope-dap.nvim', -- telescope integration with dap
    },
    keys = {
        { "<leader>dv", function() require("dap-view").toggle() end, desc = "Toggle DAP View" },
    },
    opts = {
        winbar = {
            show = true,
            -- You can add a "console" section to merge the terminal with the other views
            sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "sessions" },
            -- Must be one of the sections declared above
            default_section = "watches",
            -- Append hints with keymaps within the labels
            show_keymap_hints = true,
            -- List of up to 2 strings, defining left and right separators
            separators = nil,
            -- Configure each section individually
            base_sections = {
                -- Labels can be set dynamically with functions
                -- Each function receives the window's width and the current section as arguments
                breakpoints = { label = "Breakpoints", keymap = "B" },
                scopes = { label = "Scopes", keymap = "S" },
                exceptions = { label = "Exceptions", keymap = "E" },
                watches = { label = "Watches", keymap = "W" },
                threads = { label = "Threads", keymap = "T" },
                repl = { label = "REPL", keymap = "R" },
                sessions = { label = "Sessions", keymap = "K" },
                console = { label = "Console", keymap = "C" },
            },
            -- Add your own sections
            custom_sections = {},
            controls = {
                enabled = true,
                position = "right",
                buttons = {
                    "play",
                    "step_into",
                    "step_over",
                    "step_out",
                    "step_back",
                    "run_last",
                    "terminate",
                    "disconnect",
                },
                custom_buttons = {},
            },
        },
        windows = {
            size = 0.25,
            position = "below",
            terminal = {
                size = 0.5,
                position = "left",
                -- List of debug adapters for which the terminal should be ALWAYS hidden
                -- Can also be set to "true" to never show the terminal
                hide = {},
            },
        },
        -- Bindings can be disabled by assigning to an empty table
        keymaps = {
            scopes = {
                toggle = { "<CR>", "<2-LeftMouse>" },
                jump_to_parent = "[[",
                set_value = "s",
            },
            watches = {
                toggle = { "<CR>", "<2-LeftMouse>" },
                jump_to_parent = "[[",
                set_value = "s",
                copy_value = "c",
                delete_expression = "d",
                append_expression = "a",
                insert_expression = "i",
                edit_expression = "e",
            },
            hover = {
                quit = "q",
                toggle = { "<CR>", "<2-LeftMouse>" },
                jump_to_parent = "[[",
                set_value = "s",
            },
            help = {
                quit = "q",
            },
            console = {
                next_session = "]s",
                prev_session = "[s",
            },
            threads = {
                toggle_subtle_frames = "t",
                filter = "f",
                invert_filter = "o",
                jump_to_frame = { "<CR>", "<2-LeftMouse>" },
                force_jump = "<C-w><CR>",
            },
            exceptions = {
                toggle_filter = { "<CR>", "<2-LeftMouse>" },
            },
            sessions = {
                switch_session = { "<CR>", "<2-LeftMouse>" },
            },
            breakpoints = {
                delete_breakpoint = "d",
                jump_to_breakpoint = { "<CR>", "<2-LeftMouse>" },
                force_jump = "<C-w><CR>",
            },
            base = {
                next_view = "]v",
                prev_view = "[v",
                jump_to_first = "[V",
                jump_to_last = "]V",
                help = "g?",
            },
        },
        icons = {
            collapsed = "󰅂 ",
            disabled = "",
            disconnect = "",
            enabled = "",
            expanded = "󰅀 ",
            filter = "󰈲",
            negate = " ",
            pause = "",
            play = "",
            run_last = "",
            step_back = "",
            step_into = "",
            step_out = "",
            step_over = "",
            terminate = "",
        },
        help = {
            border = nil,
        },
        hover = {
            border = nil,
        },
        render = {
            -- Optionally a function that takes two `dap.Variable`'s as arguments
            -- and is forwarded to a `table.sort` when rendering variables in the scopes view
            sort_variables = nil,
            -- Full control of how frames are rendered, see the "Custom Formatting" page
            threads = {
                -- Choose which items to display and how
                -- Align columns
                align = false,
            },
            -- Full control of how breakpoints are rendered, see the "Custom Formatting" page
        },
        -- Requires neovim 0.12+
        virtual_text = {
            -- Control with `DapViewVirtualTextToggle`
            enabled = true,
            -- Supported options include "inline", "eol", and "eol_right_align"
            position = "inline",
            format = function(variable, _, _)
                return " " .. variable.value
            end,
            -- Prepend the variable name (when using eol positioning)
            prefix = function(position, node, bufnr)
                if position == "eol" or position == "eol_right_align" then
                    local name = vim.treesitter.get_node_text(node, bufnr)

                    return name .. " ="
                end
            end,
            -- Add commas between variables (when using eol positioning)
            suffix = function(position, _, _, var_index, num_var_line)
                if position == "eol" or position == "eol_right_align" then
                    return var_index == num_var_line and "" or ","
                end
            end,
        },
        -- Controls how to jump when selecting a breakpoint or navigating the stack
        -- Comma separated list, like the built-in 'switchbuf'. See :help 'switchbuf'
        -- Only a subset of the options is available: newtab, useopen, usetab and uselast
        -- Can also be a function that takes the current winnr and the destination bufnr
        -- If a function, should return the winnr of the destination window
        switchbuf = "usetab,uselast",
        -- Auto open when a session is started and auto close when all sessions finish
        -- Alternatively, can be a string:
        -- - "keep_terminal": as above, but keeps the terminal when the session finishes
        -- - "open_term": open the terminal when starting a new session, nothing else
        auto_toggle = false,
        -- Reopen dapview when switching to a different tab
        -- Can also be a function to dynamically choose when to follow, by returning a boolean
        -- If a function, receives the name of the adapter for the current session as an argument
        follow_tab = false,
    },
    config = function(_, opts)
        local dap_view = require("dap-view")
        vim.hl = vim.highlight
        dap_view.setup(opts)

        -- 3. Hook into nvim-dap events to automatically open/close the view
        local dap = require("dap")

        dap.configurations.java = {
            {
                name = "Debug Launch (2GB)",
                type = 'java',
                request = 'launch',
                vmArgs = "" ..
                    "-Xmx2g "
            },
            {
                name = "Debug Attach (8000)",
                type = 'java',
                request = 'attach',
                hostName = "127.0.0.1",
                port = 8000,
            },
            {
                name = "Debug Attach (5005)",
                type = 'java',
                request = 'attach',
                hostName = "127.0.0.1",
                port = 5005,
            },
            {
                name = "Dev -server",
                type = "java",
                request = "launch",
                -- You need to extend the classPath to list your dependencies.
                -- `nvim-jdtls` would automatically add the `classPaths` property if it is missing
                -- classPaths = {},

                -- If using multi-module projects, remove otherwise.
                projectName = "datahub-app-client",

                javaExec = "java",
                mainClass = "lib.main.Server",

                args =
                "-export //localhost:8010/SmartServer -db /nxdh/conf/database.cfg -loglevel EFWIT -nodbchk -v /nxdh/conf/verbose.cfg -log NONE",

                -- If using the JDK9+ module system, this needs to be extended
                -- `nvim-jdtls` would automatically populate this property
                -- modulePaths = {},
                vmArgs = "" ..
                    "-server -Xmx2G -Xms512M -Djava.locale.providers=COMPAT,CLDR  -Dfile.encoding=UTF-8 --add-opens java.base/java.nio=ALL-UNNAMED"
            },
            {
                name = "Dev -server 1 (elastic cluster)",
                type = "java",
                request = "launch",
                projectName = "datahub-app-client",
                javaExec = "java",
                mainClass = "lib.main.Server",
                args =
                "-export //localhost:8010/SmartServer -db /nxdh/conf/database.cfg -loglevel EFWIT -nodbchk -v /nxdh/conf/verbose.cfg -log NONE -elasticcluster /nxdh/conf/cluster.cfg -P SERVER_SMART_0",
                vmArgs = "" ..
                    "-server -Xmx2G -Xms512M -Djava.locale.providers=COMPAT,CLDR  -Dfile.encoding=UTF-8 --add-opens java.base/java.nio=ALL-UNNAMED"
            },
            {
                name = "Dev -server 2 (elastic cluster)",
                type = "java",
                request = "launch",
                projectName = "datahub-app-client",
                javaExec = "java",
                mainClass = "lib.main.Server",
                args =
                "-export //localhost:9010/SmartServer -db /nxdh/conf/database.cfg -loglevel EFWIT -nodbchk -v /nxdh/conf/verbose.cfg -log NONE -elasticcluster /nxdh/conf/cluster.cfg -P SERVER_SMART_1",
                vmArgs = "" ..
                    "-server -Xmx2G -Xms512M -Djava.locale.providers=COMPAT,CLDR  -Dfile.encoding=UTF-8 --add-opens java.base/java.nio=ALL-UNNAMED"
            },
            {
                name = "Dev -sheduler 1 (elastic cluster)",
                type = "java",
                request = "launch",
                projectName = "datahub-app-client",
                javaExec = "java",
                mainClass = "lib.main.Run",
                console = "integratedTerminal",
                args =
                "-user Scheduler -P SCHEDULER_SMART_0 -daemon scheduler -log NONE -loglevel EFWIT -v /nxdh/conf/verbose.cfg -network /nxdh/conf/network.cfg -cluster SERVER_SMART_0=//localhost:9010/SmartServer; -clustermode -P SCHEDULER_SMART_0 -terminationPeriod 1800 -terminationMarkPath /tmp -multiprocess /nxdh/conf/multiprocess.cfg",
                vmArgs = "" ..
                    "-server -Xmx2G -Xms512M -Djava.locale.providers=COMPAT,CLDR  -Dfile.encoding=UTF-8 --add-opens java.base/java.nio=ALL-UNNAMED"
            },
            {
                name = "Dev -sheduler 1 (multiprocess cloud)",
                type = "java",
                request = "launch",
                projectName = "datahub-app-client",
                javaExec = "java",
                mainClass = "lib.main.Run",
                console = "integratedTerminal",
                args =
                "-user Scheduler -P SCHEDULER_SMART_0 -daemon scheduler -log NONE -loglevel EFWIT -v /nxdh/conf/verbose.cfg -network /nxdh/conf/network.cfg -s //10.1.1.194:8010/SmartServer -clustermode -P SCHEDULER_SMART_0 -terminationPeriod 1800 -terminationMarkPath /tmp -multiprocess /nxdh/conf/multiprocess.cfg",
                vmArgs = "" ..
                    "-server -Xmx2G -Xms512M -Djava.locale.providers=COMPAT,CLDR  -Dfile.encoding=UTF-8 --add-opens java.base/java.nio=ALL-UNNAMED"
            }

        }
        dap.listeners.after.event_initialized["dap-view"] = function()
            dap_view.open()
        end
        dap.listeners.before.event_terminated["dap-view"] = function()
            dap_view.close()
        end
        dap.listeners.before.event_exited["dap-view"] = function()
            dap_view.close()
        end


        require("dap-go").setup()
    end,



}
