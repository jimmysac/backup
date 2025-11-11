-- LaTeX keymaps
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "plaintex" },
  callback = function()

    -- Set keymap only for LaTeX files
    vim.keymap.set("i", ";i", "\\textit{}<Esc>i", { buffer = true, noremap = true, desc = "Insert italics" })
    vim.keymap.set("i", ";b", "\\textbf{}<Esc>i", { buffer = true, noremap = true, desc = "Insert bold text" })
    vim.keymap.set("i", ";u", "\\underline{}<Esc>i", { buffer = true, noremap = true, desc = "Insert underline" })

    -- Keymaps for sections
    vim.keymap.set("i", ";s", "\\section{}<Esc>i", { buffer = true, noremap = true, desc = "Insert section" })
    vim.keymap.set("i", ";ss", "\\subsection{}<Esc>i", { buffer = true, noremap = true, desc = "Insert subsection" })
    vim.keymap.set("i", ";sss", "\\subsubsection{}<Esc>i", { buffer = true, noremap = true, desc = "Insert subsubsection" })

    -- Keymaps for lists
    vim.keymap.set("i", ";li", "\\begin{itemize}<CR><Tab>\\item <CR>\\item <CR><BS>\\end{itemize}<Esc>kkA", { buffer = true, noremap = true, desc = "Insert itemized list" })
    vim.keymap.set("i", ";le", "\\begin{enumerate}<CR><Tab>\\item <CR>\\item <CR><BS>\\end{enumerate}<Esc>kkA", { buffer = true, noremap = true, desc = "Insert enumerated list" })

    -- Keymaps for importing templates
    vim.keymap.set("n", ";1", ":r ~/Documents/Templates/Basic/basic.tex<CR>kdd", { noremap = true, silent = true, desc = "Import basic template" })

    vim.keymap.set("i", ";$", "$$<Esc>i", { noremap = true, silent = true, desc = "Inset inline math" })
    vim.keymap.set("i", ";4", "$$<Esc>i", { noremap = true, silent = true, desc = "Inset inline math" })
    vim.keymap.set("i", "44", "$$<Esc>i", { noremap = true, silent = true, desc = "Inset inline math" })

    -- Compile current file with xelatex on ;; in normal mode
    vim.keymap.set("n", ";;", function()
      vim.cmd("write") 
      local file = vim.fn.expand("%:p")
      vim.fn.jobstart({ "xelatex", "-interaction=nonstopmode", file }, {
        on_exit = function(_, exit_code)
          if exit_code == 0 then
            print("✅ xelatex compilation successful!")
          else
            print("❌ xelatex compilation failed with exit code " .. exit_code)
          end
        end,
      })
    end, { buffer = true, noremap = true, silent = true, desc = "Save & compile with xelatex" })

  -- Keymap to open corresponding pdf in evince
  vim.keymap.set("n", ";v", function() 
    local pdf = vim.fn.expand("%:r") .. ".pdf" 
    vim.fn.jobstart({ "evince", pdf }) 
  end, { buffer = true, noremap = true, silent = true, desc = "Open PDF with evince" })

  -- Helper: detect if inside math zone
    local function in_math_zone()
      -- Prefer vimtex if available
      if vim.fn.exists("*vimtex#syntax#in_mathzone") == 1 then
        return vim.fn["vimtex#syntax#in_mathzone"]() == 1
      else
        -- Fallback heuristic for basic detection
        local line = vim.api.nvim_get_current_line()
        local before = line:sub(1, vim.fn.col(".") - 1)
        return before:match("%$") and not before:match("%$.*%$")
      end
    end

local function in_math_zone()
  if vim.fn.exists("*vimtex#syntax#in_mathzone") == 1 then
    return vim.fn["vimtex#syntax#in_mathzone"]() == 1
  else
    local line = vim.api.nvim_get_current_line()
    local col = vim.fn.col(".")
    local before = line:sub(1, col - 1)
    local after = line:sub(col)

    -- Count number of inline math $ before cursor on the current line
    local inline_count = 0
    for _ in before:gmatch("%$") do
      inline_count = inline_count + 1
    end

    -- Count number of display math $$ before cursor on the current line
    local display_count = 0
    for _ in before:gmatch("%$%$") do
      display_count = display_count + 1
    end

    -- Remove display math pairs from inline math count (each $$ has two $)
    inline_count = inline_count - display_count * 2

    -- If number of inline $ before cursor is odd, we are inside inline math
    if inline_count % 2 == 1 then
      return true
    end

    -- For display math, check if number of $$ before cursor is odd (inside $$...$$)
    -- We count the occurrences of $$ before cursor and after cursor on the line
    local total_display = 0
    -- Count total $$ on line (pairs)
    for _ in line:gmatch("%$%$") do
      total_display = total_display + 1
    end

    -- Count $$ before cursor
    local before_display = 0
    for _ in before:gmatch("%$%$") do
      before_display = before_display + 1
    end

    -- If number of $$ before cursor is odd, inside display math
    if before_display % 2 == 1 then
      return true
    end

    -- Otherwise not in math zone
    return false
  end
end


    -- Helper to define math-only keymaps
    local function math_key(lhs, rhs, desc)
      vim.keymap.set("i", lhs, function()
        if in_math_zone() then
          return rhs
        else
          return lhs -- insert literal text if not in math mode
        end
      end, { buffer = true, noremap = true, expr = true, desc = desc })
    end

    -- 📐 Math-specific shortcuts
    math_key(";int", "\\int_{}^{}<Esc>F{i", "Insert integral")
    math_key(";fr", "\\frac{}{}<Esc>F{i", "Insert fraction")
    math_key(";sum", "\\sum_{}^{}<Esc>F{i", "Insert summation")
    math_key(";sq", "\\sqrt{}<Esc>i", "Insert square root")
    math_key(";al", "\\alpha", "Insert α")
    math_key(";be", "\\beta", "Insert β")
    math_key(";ga", "\\gamma", "Insert γ")
    math_key(";th", "\\therefore", "Insert therefore symbol")


  end,
})

-- 🌐 HTML keymaps
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html" },
  callback = function()
    local function open_in_firefox()
      -- Save the current buffer
      vim.cmd("write")

      -- Get full path to file
      local file = vim.fn.expand("%:p")

      -- Launch in new Firefox window
      vim.fn.jobstart({ "firefox", "--new-window", file }, { detach = true })
    end

    -- Normal mode keymap: save & open in Firefox
    vim.keymap.set("n", ";;", function()
      open_in_firefox()
    end, { buffer = true, noremap = true, silent = true, desc = "Open in Firefox" })

    -- Insert mode keymap: temporarily leave insert mode, open file, return to insert
    vim.keymap.set("i", ";;", function()
      -- Save current mode
      local mode_before = vim.fn.mode()

      -- Leave insert mode and save
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
      open_in_firefox()

      -- Restore mode if previously in insert
      if mode_before == "i" then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("a", true, false, true), "n", false)
      end
    end, { buffer = true, noremap = true, silent = true, desc = "Open in Firefox and return to insert mode" })
  end,
})

vim.api.nvim_set_keymap("n", "<F10>", ":Goyo<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<F10>", "<Esc>:Goyo<CR>i", { noremap = true, silent = true })

