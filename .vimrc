" Set tabs to two spaces
set shiftwidth=2
set tabstop=2
set softtabstop=2   " number of spaces in a tab when editing

" make tabs into spaces
set expandtab

" Show title at the top of the screen
set title

" Always show current position
set ruler

" Show line numbers
set number

" Tab completion just like in the shell
set wildmode=longest,list

" Better command-line completion
set wildmenu
 
" Show partial commands in the last line of the screen
set showcmd
 
" Highlight searches 
set hlsearch

" Search as characters are entered
set incsearch

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Show number in search
set shm=atToOI

" clear search pattern
nmap <leader>/ :let @/ = ""<CR>

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" load filetye-specific indent files
filetype indent on

" Enable folding
set foldenable
set foldlevelstart=99

" Fold based on indent
set foldmethod=indent

" ii is escape
inoremap ii <esc>
inoremap II <esc>

" Buffer control
" Switching buffer with F3 and the number from the list
:nnoremap <F3> :buffers<CR>:buffer<Space>

colorscheme ron

" stop accidentally closing vim with C-Z
noremap <C-Z> <NOP>

" NETRW
" Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
    if exists("t:expl_buf_num")
        let expl_win_num = bufwinnr(t:expl_buf_num)
        if expl_win_num != -1
            let cur_win_nr = winnr()
            echo expl_win_num
            exec expl_win_num . 'wincmd w'
            close
            exec cur_win_nr - 1 . 'wincmd w'
            unlet t:expl_buf_num
        else
            unlet t:expl_buf_num
        endif
    else
        exec '1wincmd w'
        Vexplore
        let t:expl_buf_num = bufnr("%")
    endif
endfunction
map <silent> <C-M-E> :call ToggleVExplorer()<CR>

" Hit enter in the file browser to open the selected
" file with :vsplit to the right of browser
"let g:netrw_altv = 1
" Open new files in a vertical split
let g:netrw_browse_split = 4


" Default to tree mode
let g:netrw_liststyle = 3
" Set tree-view for netrw file tree
let g:netrw_liststyle = 3

" Remove banner
let g:netrw_banner = 0

" Sets netrw size
let g:netrw_winsize = 20

" Helps grep ignore unimportant folders (comma-separated list)
set wildignore=*/node_modules/*,*/.git/*,*/.cache/*,*/#current-cloud-backend/*

" Faster saving and exiting
nnoremap <silent><leader>w :w!<CR>
nnoremap <silent><leader>q :q!<CR>
nnoremap <silent><leader>x :x<CR>
nnoremap <c-t> :tabe<CR>
" Source Vim configuration file
nnoremap <silent><leader>1 :source ~/.vimrc<CR>
" Open Vim configuration file for editing
nnoremap <silent><leader>2 :tabe ~/.vimrc<CR>
" install plugins 
nnoremap <silent><leader>3 :PlugInstall<CR>

" Easier movement between split windows CTRL + {h, j, k, l}
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" VIM-PLUG
"
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')

" Emmet for HTML and CSS
Plug 'mattn/emmet-vim'

" fzf for fuzzy search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" Surround.vim for surrounding
Plug 'tpope/vim-surround'

" Start page
Plug 'mhinz/vim-startify'

" Fugitive for git commands
Plug 'tpope/vim-fugitive'

" syntax highlighting and improved indentation.
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'jparise/vim-graphql'

" completion
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" tests
Plug 'vim-test/vim-test'

" NERDTree for navigation
Plug 'preservim/nerdtree' |
  \ Plug 'Xuyuanp/nerdtree-git-plugin'

call plug#end()


"-- NERDTree --"
" open with CTRL-E
nnoremap <C-E> :NERDTreeMirror<CR>:NERDTreeToggle<CR>
" Mirror the NERDTree before showing it. This makes it the same on all tabs.
nnoremap <C-n> :NERDTreeMirror<CR>:NERDTreeFocus<CR>

" Start NERDTree and put the cursor back in the other window.
autocmd VimEnter * NERDTree | wincmd p

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" hide the boring brackets([ ])?
let g:NERDTreeGitStatusConcealBrackets = 0 " default: 0

"-- Vim-test --"
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>S :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>
" make test commands execute using :!
let test#strategy = "basic"

" open the test file genereated from the current filename
function! OpenSpec()
  let currFileName = expand("%")
  let partial = substitute(currFileName, "/src/", "/test/unit/", "")
  let final = substitute(partial, '\.ts', '.spec.ts', "")
  exec "vs " . final 
endfunction
function! OpenSpecFile()
  let currFileName = expand("%")
  let partial = substitute(currFileName, "/test/unit/", "/src/",  "")
  let final = substitute(partial, '\.spec\.ts', '.ts', "")
  exec "vs " . final 
endfunction
nmap <silent> <leader>et :cal OpenSpec()<CR>
nmap <silent> <leader>ef :cal OpenSpecFile()<CR>

" create all necessary folders when saving a file
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END


"-- CoC extensions --"
let g:coc_global_extensions = ['coc-tsserver', 'coc-json', 'coc-pairs']

" Add CoC Prettier if prettier is installed
if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

" Add CoC ESLint if ESLint is installed
if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[j` and `]k` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [k <Plug>(coc-diagnostic-prev)
nmap <silent> [j <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gs <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>af  <Plug>(coc-fix-current)


"-- FZF CONFIG --"
" redefine entry key
map <C-p> :FZF<CR>

" set global finder key
map <C-M-p> :FZF ~/<CR>

" finder that only returns git files
command! -complete=dir -nargs=? GFiles 
  \ call fzf#run(fzf#wrap('FZF', {'source': 'git ls-files', 'dir': <q-args>}))
map <M-S-p> :GFiles<CR>

" set window layout
" - down / up / left / right
let g:fzf_layout = { 'down': '30%' }

" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history
" - History files will be stored in the specified directory
" - When set, CTRL-N and CTRL-P will be bound to 'next-history' and
"   'previous-history' instead of 'down' and 'up'.
let g:fzf_history_dir = '~/.local/share/fzf-history'

" Set colors for diff to not be those terrible ones
hi Pmenu ctermfg=White ctermbg=Black
hi PmenuSel ctermfg=White ctermbg=Black
hi FgCocErrorFloatBgCocFloating ctermfg=White ctermbg=Black guifg=White guibg=Black
hi DiffAdd      ctermfg=Black          ctermbg=DarkGreen
hi DiffChange   ctermfg=Black          ctermbg=LightMagenta
hi DiffDelete   ctermfg=Black     ctermbg=Red
hi DiffText     ctermfg=Black        ctermbg=Magenta

"-- startify --"
" do not change working directory
let g:startify_change_to_dir = 0

" set startify header
let g:startify_custom_header = 'startify#pad(startify#fortune#boxed())'
let g:startify_custom_header_quotes = [
  \ [
  \     "帝京篇十首 一",
  \   "秦川雄帝宅，函谷壯皇居。",
  \   "綺殿千尋起，離宮百雉餘。",
  \   "連甍遙接漢，飛觀迥凌虛。",
  \   "雲日隱層闕，風煙出綺疎。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "帝京篇十首 二",
  \   "巖廊罷機務，崇文聊駐輦。",
  \   "玉匣啓龍圖，金繩披鳳篆。",
  \   "韋編斷仍續，縹帙舒還卷。",
  \   "對此乃淹留，欹案觀墳典。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "帝京篇十首 三",
  \   "移步出詞林，停輿欣武宴。",
  \   "琱弓寫明月，駿馬疑流電。",
  \   "驚雁落虛弦，啼猿悲急箭。",
  \   "閱賞誠多美，於茲乃忘倦。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "帝京篇十首 四",
  \   "鳴笳臨樂館，眺聽歡芳節。",
  \   "急管韻朱絃，清歌凝白雪。",
  \   "彩鳳肅來儀，玄鶴紛成列。",
  \   "去茲鄭衛聲，雅音方可悅。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "帝京篇十首 五",
  \   "芳辰追逸趣，禁苑信多奇。",
  \   "橋形通漢上，峰勢接雲危。",
  \   "煙霞交隱映，花鳥自參差。",
  \   "何如肆轍跡？萬里賞瑤池。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "帝京篇十首 六",
  \   "飛蓋去芳園，蘭橈遊翠渚。",
  \   "萍間日彩亂，荷處香風舉。",
  \   "桂楫滿中川，弦歌振長嶼。",
  \   "豈必汾河曲，方爲歡宴所。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "帝京篇十首 七",
  \   "落日雙闕昏，回輿九重暮。",
  \   "長煙散初碧，皎月澄輕素。",
  \   "搴幌翫琴書，開軒引雲霧。",
  \   "斜漢耿層閣，清風搖玉樹。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "帝京篇十首 八",
  \   "歡樂難再逢，芳辰良可惜。",
  \   "玉酒泛雲罍，蘭殽陳綺席。",
  \   "千鍾合堯禹，百獸諧金石。",
  \   "得志重寸陰，忘懷輕尺璧。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "帝京篇十首 九",
  \   "建章歡賞夕，二八盡妖妍。",
  \   "羅綺昭陽殿，芬芳玳瑁筵。",
  \   "珮移星正動，扇掩月初圓。",
  \   "無勞上懸圃，即此對神仙。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "帝京篇十首 十",
  \   "以茲遊觀極，悠然獨長想。",
  \   "披卷覽前蹤，撫躬尋既往。",
  \   "望古茅茨約，瞻今蘭殿廣。",
  \   "人道惡高危，虛心戒盈蕩。",
  \   "奉天竭誠敬，臨民思惠養。",
  \   "納善察忠諫，明科慎刑賞。",
  \   "六五誠難繼，四三非易仰。",
  \   "廣待淳化敷，方嗣云亭響。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "飲馬長城窟行",
  \   "塞外悲風切，交河冰已結。",
  \   "瀚海百重波，陰山千里雪。",
  \   "迥戍危烽火，層巒引高節。",
  \   "悠悠卷斾旌，飲馬出長城。",
  \   "寒沙連騎跡，朔吹斷邊聲。",
  \   "胡塵清玉塞，羌笛韻金鉦。",
  \   "絕漠干戈戢，車徒振原隰。",
  \   "都尉反龍堆，將軍旋馬邑。",
  \   "揚麾氛霧靜，紀石功名立。",
  \   "荒裔一戎衣，靈臺凱歌入。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "執契靜三邊",
  \   "執契靜三邊，持衡臨萬姓。",
  \   "玉彩輝關燭，金華流日鏡。",
  \   "無爲宇宙清，有美璇璣正。",
  \   "皎佩星連景，飄衣雲結慶。",
  \   "戢武耀七德，昇文輝九功。",
  \   "煙波澄舊碧，塵火息前紅。",
  \   "霜野韜蓮劒，關城罷月弓。",
  \   "錢綴榆天合，新城柳塞空。",
  \   "花銷蔥嶺雪，縠盡流沙霧。",
  \   "秋駕轉兢懷，春冰彌軫慮。",
  \   "書絕龍庭羽，烽休鳳穴戍。",
  \   "衣宵寢二難，食旰餐三懼。",
  \   "翦暴興先廢，除兇存昔亡。",
  \   "圓蓋歸天壤，方輿入地荒。",
  \   "孔海池京邑，雙河沼帝鄉。",
  \   "循躬思勵己，撫俗媿時康。",
  \   "元首佇鹽梅，股肱惟輔弼。",
  \   "羽賢崆嶺四，翼聖襄城七。",
  \   "澆俗庶反淳，替文聊就質。",
  \   "已知隆至道，共歡區宇一。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "正日臨朝",
  \   "條風開獻節，灰律動初陽。",
  \   "百蠻奉遐賮，萬國朝未央。",
  \   "雖無舜禹迹，幸欣天地康。",
  \   "車軌同八表，書文混四方。",
  \   "赫奕儼冠蓋，紛綸盛服章。",
  \   "羽旄飛馳道，鐘鼓震巖廊。",
  \   "組練輝霞色，霜戟耀朝光。",
  \   "晨宵懷至理，終媿撫遐荒。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "幸武功慶善宮",
  \   "壽丘惟舊跡，酆邑乃前基。",
  \   "粵予承累聖，懸弧亦在茲。",
  \   "弱齡逢運改，提劒鬱匡時。",
  \   "指麾八荒定，懷柔萬國夷。",
  \   "梯山咸入款，駕海亦來思。",
  \   "單于陪武帳，日逐衛文㮰。",
  \   "端扆朝四岳，無爲任百司。",
  \   "霜節明秋景，輕冰結水湄。",
  \   "芸黃徧原隰，禾穎積京畿。",
  \   "共樂還鄉宴，歡比大風詩。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "重幸武功",
  \   "代馬依朔吹，驚禽愁昔叢。",
  \   "況茲承眷德，懷舊感深衷。",
  \   "積善忻餘慶，暢武悅成功。",
  \   "垂衣天下治，端拱車書同。",
  \   "白水巡前跡，丹陵幸舊宮。",
  \   "列筵歡故老，高宴聚新豐。",
  \   "駐蹕撫田畯，回輿訪牧童。",
  \   "瑞氣縈丹闕，祥煙散碧空。",
  \   "孤嶼含霜白，遙山帶日紅。",
  \   "於焉歡擊筑，聊以詠南風。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "經破薛舉戰地",
  \   "昔年懷壯氣，提戈初仗節。",
  \   "心隨朗日高，志與秋霜潔。",
  \   "移鋒驚電起，轉戰長河決。",
  \   "營碎落星沈，陣卷橫雲裂。",
  \   "一揮氛沴靜，再舉鯨鯢滅。",
  \   "於茲俯舊原，屬目駐華軒。",
  \   "沈沙無故迹，減竈有殘痕。",
  \   "浪霞穿水淨，峰霧抱蓮昏。",
  \   "世途亟流易，人事殊今昔。",
  \   "長想眺前蹤，撫躬聊自適。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "過舊宅二首 一",
  \   "新豐停翠輦，譙邑駐鳴笳。",
  \   "園荒一徑斷，苔古半階斜。",
  \   "前池消舊水，昔樹發今花。",
  \   "一朝辭此地，四海遂爲家。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "過舊宅二首 二",
  \   "金輿巡白水，玉輦駐新豐。",
  \   "紐落藤披架，花殘菊破叢。",
  \   "葉鋪荒草蔓，流竭半池空。",
  \   "紉珮蘭凋徑，舒圭葉翦桐。",
  \   "昔地一蕃內，今宅九圍中。",
  \   "架海波澄鏡，韜戈器反農。",
  \   "八表文同軌，無勞歌大風。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "還陝述懷",
  \   "慨然撫長劒，濟世豈邀名。",
  \   "星旂紛電舉，日羽肅天行。",
  \   "徧野屯萬騎，臨原駐五營。",
  \   "登山麾武節，背水縱神兵。",
  \   "在昔戎戈動，今來宇宙平。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "入潼關",
  \   "崤函稱地險，襟帶壯兩京。",
  \   "霜峰直臨道，冰河曲繞城。",
  \   "古木參差影，寒猿斷續聲。",
  \   "冠蓋往來合，風塵朝夕驚。",
  \   "高談先馬度，僞曉預雞鳴。",
  \   "棄繻懷遠志，封泥負壯情。",
  \   "別有真人氣，安知名不名。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "於北平作",
  \   "翠野駐戎軒，盧龍轉征斾。",
  \   "遙山麗如綺，長流縈似帶。",
  \   "海氣百重樓，巖松千丈蓋。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "遼城望月",
  \   "玄兔月初明，澄輝照遼碣。",
  \   "映雲光暫隱，隔樹花如綴。",
  \   "魄滿桂枝圓，輪虧鏡彩缺。",
  \   "臨城却影散，帶暈重圍結。",
  \   "駐蹕俯九都，停觀妖氛滅。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "春日登陝州城樓俯眺原野迴丹碧綴煙霞密翠斑紅芳菲花柳即目川岫聊以命篇",
  \   "碧原開霧隰，綺嶺峻霞城。",
  \   "煙峰高下翠，日浪淺深明。",
  \   "斑紅粧橤樹，圓青壓溜荆。",
  \   "迹巖勞傅想，窺野訪莘情。",
  \   "巨川何以濟，舟楫佇時英。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "春日玄武門宴羣臣",
  \   "韶光開令序，淑氣動芳年。",
  \   "駐輦華林側，高宴柏梁前。",
  \   "紫庭文珮滿，丹墀衮紱連。",
  \   "九夷簉瑤席，五狄列瓊筵。",
  \   "娛賓歌湛露，廣樂奏鈞天。",
  \   "清尊浮綠醑，雅曲韻朱弦。",
  \   "粵余君萬國，還慙撫八埏。",
  \   "庶幾保貞固，虛己厲求賢。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "登三臺言志",
  \   "未央初壯漢，阿房昔侈秦。",
  \   "在危猶騁麗，居奢遂役人。",
  \   "豈如家四海，日宇罄朝倫。",
  \   "扇天裁戶舊，砌地翦基新。",
  \   "引月擎宵桂，飄雲逼曙鱗。",
  \   "露除光炫玉，霜闕映雕銀。",
  \   "舞接花梁燕，歌迎鳥路塵。",
  \   "鏡池波太液，莊苑麗宜春。",
  \   "作異甘泉日，停非路寢辰。",
  \   "念勞慙逸己，居曠返勞神。",
  \   "所欣成大厦，宏材佇渭濱。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "出獵",
  \   "楚王雲夢澤，漢帝長楊宮。",
  \   "豈若因農暇，閱武出轘嵩。",
  \   "三驅陳銳卒，七萃列材雄。",
  \   "寒野霜氛白，平原燒火紅。",
  \   "琱戈夏服箭，羽騎綠沈弓。",
  \   "怖獸潛幽壑，驚禽散翠空。",
  \   "長煙晦落景，灌木振嚴風。",
  \   "所爲除民瘼，非是悅林叢。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "冬狩",
  \   "烈烈寒風起，慘慘飛雲浮。",
  \   "霜濃凝廣隰，冰厚結清流。",
  \   "金鞍移上苑，玉勒騁平疇。",
  \   "旌旗四望合，罝羅一面求。",
  \   "楚踣爭兕殪，秦亡角鹿愁。",
  \   "獸忙投密樹，鴻驚起礫洲。",
  \   "騎斂原塵靜，戈迴嶺日收。",
  \   "心非洛汭逸，意在渭濱游。",
  \   "禽荒非所樂，撫轡更招憂。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "春日望海",
  \   "披襟眺滄海，憑軾翫春芳。",
  \   "積流橫地紀，疎派引天潢。",
  \   "仙氣凝三嶺，和風扇八荒。",
  \   "拂潮雲布色，穿浪日舒光。",
  \   "照岸花分彩，迷雲雁斷行。",
  \   "懷卑運深廣，持滿守靈長。",
  \   "有形非易測，無源詎可量。",
  \   "洪濤經變野，翠島屢成桑。",
  \   "之罘思漢帝，碣石想秦皇。",
  \   "霓裳非本意，端拱且圖王。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "臨洛水",
  \   "春蒐馳駿骨，總轡俯長河。",
  \   "霞處流縈錦，風前瀁卷羅。",
  \   "水花翻照樹，堤蘭倒插波。",
  \   "豈必汾陰曲，秋雲發棹歌。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "望終南山",
  \   "重巒俯渭水，碧嶂插遙天。",
  \   "出紅扶嶺日，入翠貯巖煙。",
  \   "疊松朝若夜，複岫闕疑全。",
  \   "對此恬千慮，無勞訪九仙。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "元日",
  \   "高軒曖春色，邃閣媚朝光。",
  \   "彤庭飛綵斾，翠幌曜明璫。",
  \   "恭己臨四極，垂衣馭八荒。",
  \   "霜戟列丹陛，絲竹韻長廊。",
  \   "穆矣熏風茂，康哉帝道昌。",
  \   "繼文遵後軌，循古鑒前王。",
  \   "草秀故春色，梅豔昔年粧。",
  \   "巨川思欲濟，終以寄舟航。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "初春登樓即目觀作述懷",
  \   "憑軒俯蘭閣，眺矚散靈襟。",
  \   "綺峰含翠霧，照日蕊紅林。",
  \   "鏤丹霞錦岫，殘素雪斑岑。",
  \   "拂浪堤垂柳，嬌花鳥續吟。",
  \   "連甍豈一拱，衆幹如千尋。",
  \   "明非獨材力，終藉棟梁深。",
  \   "彌懷矜樂志，更懼戒盈心。",
  \   "媿制勞居逸，方規十產金。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "首春",
  \   "寒隨窮律變，春逐鳥聲開。",
  \   "初風飄帶柳，晚雪間花梅。",
  \   "碧林青舊竹，綠沼翠新苔。",
  \   "芝田初雁去，綺樹巧鸎來。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "初晴落景",
  \   "晚霞聊自怡，初晴彌可喜。",
  \   "日晃百花色，風動千林翠。",
  \   "池魚躍不同，園鳥聲還異。",
  \   "寄言博通者，知予物外志。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "初夏",
  \   "一朝春夏改，隔夜鳥花遷。",
  \   "陰陽深淺葉，曉夕重輕煙。",
  \   "哢鸎猶響殿，橫絲正網天。",
  \   "珮高蘭影接，綬細草紋連。",
  \   "碧鱗驚櫂側，玄燕舞檐前。",
  \   "何必汾陽處，始復有山泉。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "度秋",
  \   "夏律昨留灰，秋箭今移晷。",
  \   "峨嵋岫初出，洞庭波漸起。",
  \   "桂白發幽巖，菊黃開灞涘。",
  \   "運流方可歎，含毫屬微理。",
  \     "太宗皇帝"
  \ ],
  \ [
  \     "七夕宴懸圃二首 一",
  \   "羽蓋飛天漢，鳳駕越層巒。",
  \   "俱歎三秋阻，共敍一宵歡。",
  \   "璜虧夜月落，靨碎曉星殘。",
  \   "誰能重操杼，纖手濯清瀾。",
  \     "高宗皇帝"
  \ ],
  \ [
  \     "九月九日幸臨渭亭登高得秋字",
  \   "九月正乘秋，三杯興已周。",
  \   "泛桂迎尊滿，吹花向酒浮。",
  \   "長房萸早熟，彭澤菊初收。",
  \     "中宗皇帝"
  \ ],
  \ [
  \     "登驪山高頂寓目",
  \   "四郊秦漢國，八水帝王都。",
  \   "閶闔雄里閈，城闕壯規模。",
  \   "貫渭稱天邑，含岐實奧區。",
  \   "金門披玉館，因此識皇圖。",
  \     "中宗皇帝"
  \ ],
  \ [
  \     "橫吹曲辭 關山月",
  \   "明月出天山，蒼茫雲海間。",
  \   "長風幾萬里，吹度玉門關。",
  \   "漢下白登道，胡窺青海灣。",
  \   "由來征戰地，不見有人還。",
  \   "戍客望邊色，思歸多苦顏。",
  \   "高樓當此夜，歎息未應閑。",
  \     "李白"
  \ ],
  \]
