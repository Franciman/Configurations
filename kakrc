# ------------------------------------------------------------------------------------------------------
# Generic definitions and hooks

hook global WinCreate .* %[
    addhl number_lines
]

define-command ide %[
    rename-client main
    set global jumpclient main

    new rename-client tools
    set global toolsclient tools

    new rename-client docs
    set global docsclient docs
]


# ------------------------------------------------------------------------------------------------------
# C++

define-command -hidden cpp-indent-on-colon %[
    try %[
        exec -draft <a-x> <a-k>\h*(public|private|protected)<ret> <lt>
    ]
]

hook global WinSetOption filetype=cpp %[

    hook window InsertChar : cpp-indent-on-colon

    hook buffer BufWritePost .* clang-parse

    set window clang_options '-std=c++14'

     #%sh[
        #flags_finder='/home/francesco/Projects/ClangConfReader/clang_conf_reader'
        #flags=$($flags_finder)
        #echo "set buffer clang_options '$flags'"
    #]

    %sh[
    	if [ $PWD = "/home/francesco/Projects/v22" ]; then
            echo "set global makecmd '/home/francesco/Projects/v22/tools/waf'"
        fi
    ]

    alias window lint clang-parse
    alias window lint-next clang-diagnostics-next

    alias window parse clang-parse
    alias window next clang-diagnostics-next

    clang-enable-autocomplete
    clang-enable-diagnostics

]

#---------------------------------------------------------------------------------------------
# Ergonomic maps

map global user y %{<a-|>xclip -i -selection clipboard<ret>} -docstring "yank to clipboard"
map global user p %{<a-!>xclip -o -selection clipboard<ret>} -docstring "Paste from clipboard"
map global user d %{,yd} -docstring "yank to clipboard and delete"

map global normal <c-e> vj
map global normal <c-y> vk

# Vim-esque split
define-command sp -params 1 -file-completion %[
    new edit %arg[1]
]

# -------------------------------------------------------------------------------------------------
# Haskell

hook global WinSetOption filetype=haskell %[
    map buffer insert <tab> '<a-;><gt>'
    map buffer insert <backtab> '<a-;><lt>'
]

# --------------------------------------------------------------------------------------------------
# Rust

define-command racer-type-signature %[
    echo %sh{
        cursor="${kak_cursor_line} $((${kak_cursor_column} - 1))"
        # TODO: Maybe we should use a substitute file,
        # even if I don't think i'll keep on writing when waiting for infos
        racer_data=$(racer --interface tab-text find-definition ${cursor} ${kak_buffile})
        definition=$(printf %s\\n "${racer_data}" | awk '
            BEGIN { FS = "\t" }
            /^MATCH/ {
                print $7
            }'
        )

        printf "%%[%s]" "${definition}"
    }
]

hook global WinSetOption filetype=rust %[
    racer-enable-autocomplete
    map global user s ':racer-type-signature<ret>' -docstring "Get signature of rust function under the cursor"
]

#---------------------------------------------------------------------------------------------------
# Blog post commands

declare-option str blog_post_template '<lt>div<gt><ret><lt>h2<gt><lt>/h2<gt><ret><lt>p<gt><lt>/p<gt><ret><lt>/div<gt>'
define-command new-blog-post %{
    exec "/<lt>body<gt><ret>jo%opt{blog_post_template}<esc>k<gt>k<gt>glbhhi"
}


# --------------------------------------------------------------------------------------------------
# Colorscheme

colorscheme gruvbox
