def -hidden cpp-indent-on-colon %[
    try %[
        exec -draft <a-x> <a-k>\h*(public|private|protected)<ret> <lt>
    ]
]

def -hidden cpp-indent-on-newline %[
    try %[
        # If previous line was { don't indent it
        exec -draft k<a-x> <a-K>\h*{\h*<ret>
        exec -draft kk<a-x> <a-k>.*\(.*\):<ret>J<a-&>\;<a-gt>
    ]
]

# TODO: This is very coarse, find a better way
def -hidden cpp-indent-brace-after-ctor-initializer-list %[
    try %[
            # Avoiding case stuff
            exec -draft <a-f>: \; <a-x> <a-K>.*\bcase\b.*:<ret>j

            exec -draft %< <a-f>: \; <a-x> <a-k>.*\(.*\):<ret>f{ \; K <a-&> <a-x> <a-K>.*\(.*\):<ret>j <a-lt> >
    ] 
]

hook global WinCreate .* %[
    addhl number_lines
]


set global termcmd 'sakura         -x      '


def ide %[
    rename-client main
    set global jumpclient main

    new rename-client tools
    set global toolsclient tools

    new rename-client docs
    set global docsclient docs
]

hook global WinSetOption filetype=cpp %[

    hook window InsertChar : cpp-indent-on-colon
    hook window InsertChar \n cpp-indent-on-newline
    hook window InsertChar \{ cpp-indent-brace-after-ctor-initializer-list

    hook buffer BufWritePost .* clang-parse

    set window clang_options '-std=c++14'

     %sh[
        flags_finder='/home/francesco/Projects/ClangConfReader/clang_conf_reader'
        flags=$($flags_finder)
        echo "set buffer clang_options '$flags'"
    ]

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

# Vim-esque split
def sp -params 1 -file-completion %[
    x11-new edit %arg[1]
]

hook global WinSetOption filetype=haskell %[
    map buffer insert <tab> '<a-;><gt>'
    map buffer insert <backtab> '<a-;><lt>'

    add-highlighter -group /haskell/code regex \b[A-Z:]\w+\b 0:type

]

colorscheme gruvbox
