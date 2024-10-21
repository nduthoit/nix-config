{ config, lib, ... }:

{
  # https://docs.haskellstack.org/en/stable/yaml_configuration/#non-project-specific-config
  home.file.".stack/config.yaml".text = lib.generators.toYAML {} {
    templates = {
      scm-init = "git";
      params = {
        author-name = config.home.user-info.fullName;
        author-email = config.home.user-info.email;
        github-username = "nduthoit";
      };
    };
    nix.enable = true;
  };

  # Baseline Vim config
  home.file.".vimrc".text = ''
    " General
    set nocompatible
    set encoding=utf-8
    set hidden
    set history=1000
    set undolevels=1000
    set autoread

    " UI
    set number
    set relativenumber
    set ruler
    set cursorline
    set showcmd
    set showmatch
    set wildmenu
    set wildmode=list:longest,full
    set laststatus=2
    set scrolloff=5
    set colorcolumn=80,120

    " Search
    set incsearch
    set hlsearch
    set ignorecase
    set smartcase

    " Indentation
    set expandtab
    set tabstop=2
    set softtabstop=2
    set shiftwidth=2
    set autoindent
    set smartindent

    " Whitespace
    set list
    set listchars=tab:▸\ ,trail:·

    " Splits
    set splitbelow
    set splitright

    " No swap/backup files cluttering repos
    set noswapfile
    set nobackup
    set nowritebackup

    " Keybindings
    let mapleader = " "
    nnoremap <leader>/ :nohlsearch<CR>
    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l
  '';

  # Stop `parallel` from displaying citation warning
  home.file.".parallel/will-cite".text = "";
}
