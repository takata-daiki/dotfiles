func! myspacevim#before() abort
    let g:clamp_autostart = 0
    let g:neomake_enabled_c_makers = ['clang']
    nnoremap jk <Esc>
endf

func! myspacevim#after() abort
    iunmap jk
endf
