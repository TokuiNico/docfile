" Encoding settings
    set encoding=utf-8                 " for Vim execution
    set fileencoding=utf-8             " for saving new files
    set fileencodings=utf-8            " for opening files

" General settings
    set nocompatible                   " be iMproved
    filetype off                       " required!
    " set relativenumber                 " display relative line numbers
    set number                         " display line numbers
    set hlsearch                       " highlight search results
    set backspace=2                    " enable backspace in insert mode
    " set cursorline                     " highlight the cursor line
    set nobackup                       " won't save backup file anymore
    set noswapfile                     " won't save swap file anymore

" neovim virtualenv
    let g:python_host_prog = '/home/chihyu_lin/virtualenv/neovim2/bin/python'
    let g:python3_host_prog = '/home/chihyu_lin/virtualenv/neovim3/bin/python'

" Programming settings
    set shiftwidth=4
    set softtabstop=4
    set tabstop=4
    set expandtab "change tab to space
    set smarttab                       " uses shiftwidth instead of tabstop at start of lines
    " set tabpagemax=100                 " change the limit of tabs
    set smartindent

    set mouse=a "use mouse

" set code folder
    set foldmethod=indent
    set foldlevel=999

" set clipboard=unnamed "use clipboard

    set ic "set ignore case of search
    set ru "set line number (right button
    set lazyredraw

    set incsearch "unincomplete search


" help speedup
    " set re=1
    set ttyfast
    set lazyredraw

" Remove trailing spaces when saving files
    autocmd BufWritePre * :%s/\s\+$//e

" key map
    " nnoremap <Leader>e :SyntasticCheck<CR> " \ + e to check syntax
    " nnoremap <Leader>ee :Errors<CR> " \ +ee to shoe error list
    nnoremap <Leader>t :TagbarToggle<CR> "\ + t to viwe tag bar
    nnoremap <Leader>f :Files<CR>
    nnoremap <Leader>l :Buffers<CR>
    nmap <silent> <C-k> <Plug>(ale_previous_wrap)
    nmap <silent> <C-j> <Plug>(ale_next_wrap)


call plug#begin()

    " clolor
        Plug 'altercation/vim-colors-solarized'
            syntax enable
            set background=dark
            set t_Co=256
            let g:solarized_termcolors=16
            colorscheme solarized


    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
        set laststatus=2 " set status line
        let g:airline#extensions#tabline#enabled = 1
        " set left separator which are not editting
        let g:airline#extensions#tabline#left_alt_sep = '|'
        " let g:airline#extensions#tabline#tab_nr_type = 1
        let g:airline#extensions#tabline#fnamemod = ':t'
        " let g:airline#extensions#tabline#show_buffers = 1
        let g:airline#extensions#tabline#buffer_idx_mode = 1
        " let g:airline#extensions#tabline#show_tab_nr = 1
        " show buffer number
        " let g:airline#extensions#tabline#buffer_nr_show = 1
        let g:airline_powerline_fonts = 1 " enable powerline-fonts
        let g:airline_theme='solarized' " set theme

    Plug 'Yggdroot/indentLine'
        let g:indentLine_char = '¦'

    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'

    Plug 'majutsushi/tagbar'
        let g:tagbar_autofocus = 1
        let g:tagbar_silent = 1
        let g:tagbar_sort = 0

    Plug 'tpope/vim-fugitive'

    Plug 'davidhalter/jedi-vim'
        " let g:jedi#completions_command = "<C-N>"
        " let g:jedi#popup_on_dot = 0
        " let g:jedi#smart_auto_mappings = 0
        " let g:jedi#show_call_signatures = 0

        " disable completions
        let g:jedi#completions_enabled = 0


    Plug 'scrooloose/nerdcommenter'
        " Add spaces after comment delimiters by default
        let g:NERDSpaceDelims = 1

        " Use compact syntax for prettified multi-line comments
        let g:NERDCompactSexyComs = 1

        " Align line-wise comment delimiters flush left instead of following code indentation
        let g:NERDDefaultAlign = 'left'

        " Set a language to use its alternate delimiters by default
        let g:NERDAltDelims_java = 1

        " Add your own custom formats or override the defaults
        let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

        " Allow commenting and inverting empty lines (useful when commenting a region)
        let g:NERDCommentEmptyLines = 1

        " Enable trimming of trailing whitespace when uncommenting
        let g:NERDTrimTrailingWhitespace = 1

    Plug 'Raimondi/delimitMate'
        " auto-completion for quotes, parens, brackets, etc

    Plug 'easymotion/vim-easymotion'
        " use \ \ w and \ \ b to move

        " Move to word
        map  <Leader>w <Plug>(easymotion-bd-w)
        nmap <Leader>w <Plug>(easymotion-overwin-w)

        " Move to line
        map <Leader>a <Plug>(easymotion-bd-jk)
        nmap <Leader>a <Plug>(easymotion-overwin-line)

    Plug 'w0rp/ale'
        let g:ale_linters = {
        \   'python': ['flake8'],
        \}
        let g:ale_python_flake8_args = '--ignore=E128,E203,E221,E226,E241,E251,E261,E262,E265,E302,E501,E701'
        let g:ale_python_flake8_executable = 'flake8'
        let g:ale_python_flake8_options = '--ignore=E128,E203,E221,E226,E241,E251,E261,E262,E265,E302,E501,E701'

        let g:ale_sign_column_always = 1

        let g:ale_sign_error = '>>'
        let g:ale_sign_warning = '--'

        let g:ale_lint_delay = 2000

        let g:ale_echo_msg_error_str = 'E'
        let g:ale_echo_msg_warning_str = 'W'
        let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

    Plug 'marksylee/vim-bundle-mako'

    Plug 'gregsexton/MatchTag'

    Plug 'Vimjas/vim-python-pep8-indent'

    " use less now
    " Plug 'dhruvasagar/vim-table-mode'
    "     let g:table_mode_corner_corner='+'
    "     let g:table_mode_header_fillchar='='

    " async Autocomplete
        Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
            let g:deoplete#enable_smart_case = 1
            let g:deoplete#enable_at_startup = 1
            let g:deoplete#disable_auto_complete = 0

        Plug 'zchee/deoplete-jedi'

        " call autocomplete manually
        " inoremap <silent><expr> <TAB>
            " \ pumvisible() ? "\<C-n>" :
            " \ <SID>check_back_space() ? "\<TAB>" :
            " \ deoplete#mappings#manual_complete()
            " function! s:check_back_space() abort "{{{
            " let col = col('.') - 1
            " return !col || getline('.')[col - 1]  =~ '\s'
            " endfunction"}}}


call plug#end()
