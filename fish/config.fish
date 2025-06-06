if status is-interactive
  # Commands to run in interactive sessions can go here
  fish_default_key_bindings
end

bind \b backward-kill-word
bind \e\[3\;5~ kill-word

function y
  set tmp (mktemp -t "yazi-cwd.XXXXXX")
  yazi $argv --cwd-file="$tmp"
  if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
    builtin cd -- "$cwd"
  end
  rm -f -- "$tmp"
end

function lg
    set -Ux LAZYGIT_NEW_DIR_FILE ~/.lazygit/newdir

    lazygit $argv

    if test -f $LAZYGIT_NEW_DIR_FILE
        cd (cat $LAZYGIT_NEW_DIR_FILE)
        rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    end
end

function nv
    nvim .
end

function cl
  set -q argv[1]; or set argv[1] "."
  cloc --vcs=git --include-ext=c,cats,ec,idc,pgc,C,c++,c++m,cc,ccm,CPP,cpp,cppm,cxx,cxxm,h++,inl,ipp,ixx,pcc,tcc,tpp,H,h,hh,hpp,hxx,css,fish,go,ʕ◔ϖ◔ʔ,java,_js,bones,cjs,es6,jake,jakefile,js,jsb,jscad,jsfl,jsm,jss,mjs,njs,pac,sjs,ssjs,xsjs,xsjslib,lua,nse,p8,pd_lua,rbxs,wlua,nix,eliom,eliomi,ml,ml4,mli,mll,mly,odin,buck,build.bazel,gclient,gyp,gypi,lmi,py,py3,pyde,pyi,pyp,pyt,pyw,sconscript,sconstruct,snakefile,tac,workspace,wscript,wsgi,xpy,rs,rs.in,cql,mysql,psql,SQL,sql,tab,udf,viw,svelte,swift,mts,tsx,ts,vim,vue,zig,zsh $argv[1]
end

function pd
 pnpm dev
end

function pi
 pnpm install --reporter default
end

alias ls="eza -alh --git --git-repos"
alias ts="tailscale"

#set -x NIX_LD (nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD ')
set -x EDITOR nvim
#set -gx PATH "/home/ufuk/.local/share/nvim/mason/bin" $PATH
set -gx PATH "/home/ufuk/projects/personal/schemadiff/bin" $PATH

# pnpm
set -gx PNPM_HOME "/home/ufuk/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

zoxide init --cmd cd fish | source

fnm env --shell fish | source
function _fnm_autoload_hook --on-variable PWD --description 'Change Node version on directory change'
    status --is-command-substitution; and return
    if test -f .node-version -o -f .nvmrc -o -f package.json
        fnm use --silent-if-unchanged
    end
end

# set -gx XDG_DATA_DIRS $XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
