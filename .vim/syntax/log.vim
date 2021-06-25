" " Vim syntax file
" " Language:         Generic log files
" " Maintainer:       Alex Dzyoba <avd@reduct.ru>
" " Latest Revision:  2013-03-08
" " Changes:          2013-03-08 Initial version

" " Based on messages.vim - syntax file for highlighting kernel messages

" if exists("b:current_syntax")
"   finish
" endif

" syn match log_bracket 	'\(\[\|]\)'
" syn match log_error 	'\c.*\<\(FATAL\|ERROR\|ERRORS\|FAIL\|FAILED\|FAILURE\).*'
" syn match log_warning 	'\c.*\<\(WARNING\|DELETE\|DELETING\|DELETED\|RETRY\|RETRYING\).*'
" syn region log_string 	start=/'[^\[]/ end=/'/ end=/$/ skip=/\\./
" syn region log_string 	start=/"[^\[]/ end=/"/ skip=/\\./
" syn region log_string 	start=/`[^\[]/ end=/`/ skip=/\\./
" I don't know who decided to start some strings with a backtic and end them
" in a quote, but I hate that person
" syn region log_string 	start=/`[^\[]/ end=/'/ skip=/\\./
" syn match log_number 	'0x[0-9a-fA-F]*\|\[<[0-9a-f]\+>\]\|\<\d[0-9a-fA-F]*'

" syn match   log_date '\(Jan\|Feb\|Mar\|Apr\|May\|Jun\|Jul\|Aug\|Sep\|Oct\|Nov\|Dec\) [ 0-9]\d *'
" syn match   log_date '\d\{4}-\d\d-\d\d'

" syn match   log_time '\d\d:\d\d:\d\d\s*'
" syn match   log_time '\c\d\d:\d\d:\d\d\(\.\d\+\)\=\([+-]\d\d:\d\d\|Z\)'

hi def link log_string  String
" hi def link log_number  Number
" hi def link log_date    Constant
" hi def link log_time    Type
" hi def link log_error   ErrorMsg
" hi def link log_warning WarningMsg

" hi def link log_bracket	Identifier


" let b:current_syntax = "log"

setlocal nowrap

if exists('b:current_syntax')
  finish
endif

if has('conceal')
  syn match railslogEscape      '\e\[[0-9;]*m' conceal
  syn match railslogEscapeMN    '\e\[[0-9;]*m' conceal nextgroup=railslogModelNum,railslogEscapeMN skipwhite contained
else
  syn match railslogEscape      '\e\[[0-9;]*m'
  syn match railslogEscapeMN    '\e\[[0-9;]*m' nextgroup=railslogModelNum,railslogEscapeMN skipwhite contained
endif
syn match   railslogQfFileName  "^[^()|]*|\@=" nextgroup=railslogQfSeparator
syn match   railslogQfSeparator "|" nextgroup=railslogQfLineNr contained
syn match   railslogQfLineNr    "[^|]*" contained contains=railslogQfError
syn match   railslogQfError     "error" contained
syn match   railslogRender      '\%(\%(^\||\)\s*\%(\e\[[0-9;]*m\)\=\)\@<=\%(Started\|Processing\|Rendering\|Rendered\|Redirected\|Completed\)\>'
syn match   railslogComment     '\%(^\|[]|]\)\@<=\s*# .*'
syn match   railslogModel       '\%(\%(^\|[]|]\)\s*\%(\e\[[0-9;]*m\)*\)\@<=\%(CACHE SQL\|CACHE\|SQL\)\>' skipwhite nextgroup=railslogModelNum,railslogEscapeMN
syn match   railslogModel       '\%(\%(^\|[]|]\)\s*\%(\e\[[0-9;]*m\)*\)\@<=\%(CACHE \)\=\u\%(\w\|:\)* \%(Load\%( Including Associations\| IDs For Limited Eager Loading\)\=\|Columns\|Exists\|Count\|Create\|Update\|Destroy\|Delete all\)\>' skipwhite nextgroup=railslogModelNum,railslogEscapeMN
syn region  railslogModelNum    start='(' end=')' contains=railslogNumber contained skipwhite
syn match   railslogActiveJob   '\[ActiveJob\]'hs=s+1,he=e-1 nextgroup=railslogJobScope skipwhite
syn match   railslogJobScope    '\[\u\%(\w\|:\)*\]' contains=railslogJobName contained
syn match   railslogJob         '\%(\%(^\|[\]|]\)\s*\%(\e\[[0-9;]*m\)*\)\@<=\%(Enqueued\|Performing\|Performed\)\>' skipwhite nextgroup=railslogJobName
syn match   railslogJobName     '\<\u\%(\w\|:\)*\>' contained
syn match   railslogNumber      '\<\d\+%'
syn match   railslogNumber      '[ (]\@<=\<\d\+\.\d\+\>\.\@!'
syn match   railslogNumber      '[ (]\@<=\<\d\+\%(\.\d\+\)\=ms\>'
syn region  railslogString      start='"' skip='\\"' end='"' oneline contained
syn region  railslogHash        start='{' end='}' oneline contains=railslogHash,railslogString
syn match   railslogIP          '\<\d\{1,3\}\%(\.\d\{1,3}\)\{3\}\>'
syn match   railslogIP          '\<\%(\x\{1,4}:\)\+\%(:\x\{1,4}\)\+\>\|\S\@<!:\%(:\x\{1,4}\)\+\>\|\<\%(\x\{1,4}:\)\+\%(:\S\@!\|\x\{1,4}\>\)'
syn match   railslogTimestamp   '\<\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d\%( [+-]\d\d\d\d\| UTC\)\=\>'
syn match   railslogSessionID   '\<\x\{32\}\>'
syn match   railslogUUID        '\<\x\{8\}-\x\{4\}-\x\{4\}-\x\{4\}-\x\{12\}\>'
syn match   railslogIdentifier  '\%(^\||\)\@<=\s*\%(Session ID\|Parameters\|Unpermitted parameters\)\ze:'
syn match   railslogSuccess     '\<2\d\d\%( \u\w*\)\+\>'
syn match   railslogRedirect    '\<3\d\d\%( \u\w*\)\+\>'
syn match   railslogError       '\<[45]\d\d\%( \u\w*\)\+\>'
syn match   railslogDeprecation '\<DEPRECATION WARNING\>'
syn keyword railslogHTTP        OPTIONS GET HEAD POST PUT PATCH DELETE TRACE CONNECT

hi def link railslogQfFileName  Directory
hi def link railslogQfLineNr    LineNr
hi def link railslogQfError     Error
hi def link railslogEscapeMN    railslogEscape
hi def link railslogEscape      Ignore
hi def link railslogComment     Comment
hi def link railslogRender      Keyword
hi def link railslogModel       Type
hi def link railslogJob         Repeat
hi def link railslogJobName     Structure
hi def link railslogNumber      Float
hi def link railslogString      String
hi def link railslogSessionID   Constant
hi def link railslogUUID        Constant
hi def link railslogIdentifier  Identifier
hi def link railslogRedirect    railslogSuccess
hi def link railslogSuccess     Special
hi def link railslogDeprecation railslogError
hi def link railslogError       Error
hi def link railslogHTTP        Special

" from ruby
" syn match rubyClassName	       "\[(.*\]"
syn match rubyClassName	       "\[\(\a\|\-\|:\|\s\)*\]"
syn match Identifier	       "\w*::\w*"
syn match Identifier	       "\w*\/\w*"



" syn match rubyModuleName       "\%(\%(^\|[^.]\)\.\s*\)\@<!\<[[:upper:]]\%(\w\|[^\x00-\x7F]\)*\>\%(\s*(\)\@!" contained
" syn match rubyConstant	       "\%(\%(^\|[^.]\)\.\s*\)\@<!\<[[:upper:]]\%(\w\|[^\x00-\x7F]\)*\>\%(\s*(\)\@!"
" syn match rubyClassVariable    "@@\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*" display
" syn match rubyInstanceVariable "@\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*"  display
" syn match rubyGlobalVariable   "$\%(\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*\|-.\)"


syn match rubyInteger "\%(\%(\w\|[^\x00-\x7F]\|[]})\"']\s*\)\@<!-\)\=\<0[xX]\x\+\%(_\x\+\)*r\=i\=\>"							       display
syn match rubyInteger "\%(\%(\w\|[^\x00-\x7F]\|[]})\"']\s*\)\@<!-\)\=\<\%(0[dD]\)\=\%(0\|[1-9]\d*\%(_\d\+\)*\)r\=i\=\>"					       display
syn match rubyInteger "\%(\%(\w\|[^\x00-\x7F]\|[]})\"']\s*\)\@<!-\)\=\<0[oO]\=\o\+\%(_\o\+\)*r\=i\=\>"							       display
syn match rubyInteger "\%(\%(\w\|[^\x00-\x7F]\|[]})\"']\s*\)\@<!-\)\=\<0[bB][01]\+\%(_[01]\+\)*r\=i\=\>"						       display
" syn match rubyFloat   "\%(\%(\w\|[^\x00-\x7F]\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\%(_\d\+\)*\)\.\d\+\%(_\d\+\)*r\=i\=\>"				       display
" syn match rubyFloat   "\%(\%(\w\|[^\x00-\x7F]\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\%(_\d\+\)*\)\%(\.\d\+\%(_\d\+\)*\)\=\%([eE][-+]\=\d\+\%(_\d\+\)*\)i\=\>" display

" syn match rubyParenthesisEscape	  "\\[()]"  contained display
" syn match rubyCurlyBraceEscape	  "\\[{}]"  contained display
" syn match rubyAngleBracketEscape  "\\[<>]"  contained display
" syn match rubySquareBracketEscape "\\[[\]]" contained display

" syn region rubyNestedParentheses    start="("  skip="\\\\\|\\)"  matchgroup=rubyString end=")"	transparent contained
" syn region rubyNestedCurlyBraces    start="{"  skip="\\\\\|\\}"  matchgroup=rubyString end="}"	transparent contained
" syn region rubyNestedAngleBrackets  start="<"  skip="\\\\\|\\>"  matchgroup=rubyString end=">"	transparent contained
" syn region rubyNestedSquareBrackets start="\[" skip="\\\\\|\\\]" matchgroup=rubyString end="\]"	transparent contained

syn match Comment	       "\d\d\d\d\-\d\d\-\d\dT\d\d\:\d\d\:\d\d\.\d\d\dZ"
syn match Comment	       "\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\d\d\d\d\d\d"
syn match Comment	       "\d\d:\d\d:\d\d"

syn match railslogError	       "albatross"
se synmaxcol=500
