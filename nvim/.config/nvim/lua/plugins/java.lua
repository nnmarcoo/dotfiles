return {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
        local function get_config()
            local jdtls = require("jdtls")
            local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

            local os_config = "config_linux"
            if vim.fn.has("mac") == 1 then
                os_config = "config_mac"
            elseif vim.fn.has("win32") == 1 then
                os_config = "config_win"
            end

            local launcher = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

            local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/"
                .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

            return {
                cmd = {
                    "java",
                    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                    "-Dosgi.bundles.defaultStartLevel=4",
                    "-Declipse.product=org.eclipse.jdt.ls.core.product",
                    "-Dlog.level=ALL",
                    "-Xmx1g",
                    "--add-modules=ALL-SYSTEM",
                    "--add-opens", "java.base/java.util=ALL-UNNAMED",
                    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
                    "-jar", launcher,
                    "-configuration", mason_path .. "/" .. os_config,
                    "-data", workspace_dir,
                },
                root_dir = jdtls.setup.find_root({
                    ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts",
                    ".classpath", ".project",
                }),
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
                settings = {
                    java = {
                        signatureHelp = { enabled = true },
                        sources = {
                            organizeImports = {
                                starThreshold = 9999,
                                staticStarThreshold = 9999,
                            },
                        },
                        codeGeneration = {
                            toString = {
                                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                            },
                            useBlocks = true,
                        },
                    },
                },
                on_attach = function(_, bufnr)
                    local opts = function(desc)
                        return { buffer = bufnr, silent = true, desc = desc }
                    end
                    vim.keymap.set("n", "<leader>ji", jdtls.organize_imports,              opts("Java: organize imports"))
                    vim.keymap.set("n", "<leader>jv", jdtls.extract_variable,              opts("Java: extract variable"))
                    vim.keymap.set("n", "<leader>jc", jdtls.extract_constant,              opts("Java: extract constant"))
                    vim.keymap.set("v", "<leader>jm", function() jdtls.extract_method(true) end, opts("Java: extract method"))
                end,
            }
        end

        local function start()
            require("jdtls").start_or_attach(get_config())
        end

        -- Start for the current buffer (lazy loaded on first Java file)
        start()

        -- Start for any subsequent Java files opened in the same session
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = start,
        })
    end,
}
