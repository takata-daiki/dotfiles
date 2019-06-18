function! myspacevim#before() abort
  let g:clamp_autostart = 0
  let g:neomake_enabled_c_makers = ['clang']
  let g:neoformat_cpp_clangformat = {
        \ 'exe': 'clang-format',
        \ 'args': ['-style=Google'],
        \ 'stdin': 1
        \ }
  let g:neoformat_enabled_cpp = ['clangformat']
  " let g:spacevim_layer_lang_java_formatter = '/Users/daiki-tak/google-java-format-1.7-all-deps.jar'
  " let g:neoformat_java_googlefmt = {
  "       \ 'exe': 'java',
  "       \ 'args': ['-jar', get(g:, 'spacevim_layer_lang_java_formatter', ''), '-'],
  "       \ 'stdin': 1
  "       \ }
  " let g:neoformat_enabled_java = ['googlefmt']
  nnoremap jk <Esc>
  call SpaceVim#logger#info('myspacevim#before called')
endfunction

function! myspacevim#after() abort
  iunmap jk
endfunction

