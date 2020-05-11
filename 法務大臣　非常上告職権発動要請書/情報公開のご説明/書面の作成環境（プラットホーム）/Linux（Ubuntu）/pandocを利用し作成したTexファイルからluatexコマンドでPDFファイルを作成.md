# pandocを利用し作成したTexファイルからluatexコマンドでPDFファイルを作成

:CATEGORIES: Ubuntu,LaTeX

 - title: "情報公開のご説明／書面の作成環境（プラットホーム）／Linux（Ubuntu）／pandocを利用し作成したTexファイルからluatexコマンドでPDFファイルを作成"
 - author: 廣野秀樹
 - date: 2020-05-11 10:23:50 +0900
 - abstract: 平成４年の傷害・準強姦被告事件につき、弁護士の犯罪関与で適正な刑事手続が行われなかったことを理由とする非常上告を検事総長に対する職権発動として求める上申書
 - FILE_NAME: pandocを利用し作成したTexファイルからluatexコマンドでPDFファイルを作成.md
 - 記事タイトル名の文字数：84　保存ファイル名の文字数：47

## pandocを利用し作成したTexファイルからluatexコマンドでPDFファイルを作成するスクリプト

:CATEGORIES: Ubuntu,LaTeX,YouTube,スクリーンキャスト

　時刻は2020年5月11日10時29分です。今回ご紹介するスクリプトは5月5日に出来上がっていたものと思いますが，今朝，実行してみたところ不具合を見つけ，その修正などしていました。まだいくつか修正の必要はあるのですが，基本形は出来ていると思います。

　さきほどスクリーンキャストの動画ファイルを作成し，YouTubeにアップロードしました。実際のパソコン画面の操作で，何をやっているのかだいたいのところはお伝えできるのではと思います。まだ不具合が残っている箇所もありますが，一部で修正済みです。

 - 2020年05月11日09時57分22秒の記録＿pandocを利用し作成したTexファイルからluatexコマンドでPDFファイルを作成 - YouTube https://www.youtube.com/watch?v=JCUjIuZQpvI

　次がスクリプトのソースコードになります。何に取り組み時間を使ってきたのかという状況もご理解いただくため，ご紹介をしておきたいと思いました。雑な作りになっているところもあると思いますが，こけつまろびずの苦心の作になります。

>|ruby|
#!/usr/bin/env ruby
#coding: utf-8
require 'date'

f = ARGV[0].dup
@name = f.sub(/\..+$/,'')
#`sed -E -i "s/^[ source :]/ - 〈引用元：〉/" "#{f}"`
`pandoc -sN -f markdown -V  documentclass=ltjarticle --pdf-engine=lualatex -t latex #{f} -o ./tmp.tex`

content = `cat ./tmp.tex |sed -nE '/\\\\begin\\{document\\}/,$p' |sed -E 's/\\\\begin\\{document\\}//'`
#content.gsub!(/```(.+?)```/m) {">《引用の始まり》\n\n#{$1.gsub(/^/,'> ')}\n\n>《引用の終わり》"}
#content.sub!(/^(\\begin\{document\})$/){$1 + "\n\n\\tableofcontents \\newpage"}
content = content.gsub(/```(.+?)```/m) {"\\begin{quote}\n#{$1}\n\\end{quote}"}
content = content.gsub(/\\begin{verbatim}(.+?)\\end{verbatim}/m) \
        {"\\begingroup\\fontsize{9pt}{10pt}\\selectfont\n\\begin{quote}\n\\begin{verbatim}\n#{$1}\n\\end{verbatim}\n\\end{quote}\\endgroup\n"}

title = @name
# File.open("tmp.txt", "w") do |f| 
#     f.puts(content)
# end

date = DateTime.now
@pdf_day = date.strftime("%Y.%m.%d")

#puts title
content_org = content
content = content.sub('\\begin\{document\}','')

begin
    content = content.sub(/.*(title: ).+/){"\\hrulefill\n\n" + $1}.sub!(/(.*\n記事タイトル名の文字数：.+?　保存ファイル名の文字数：.+?)\n/){ $1 + "\n\n\\hrulefill\n\n"}
    content = content.gsub('_', '\_')
    content = content.gsub('\\\\','\\')
rescue
    content = content_org
end

tex_header = <<"EOS"
\\begin{document}

\\tableofcontents \\newpage

\\title{#{@name}}
%\\author{\\leftline{{\\small{廣野秀樹}}}}
\\author{廣野秀樹}
\\date{#{@pdf_day}}
\\maketitle

EOS

tex_text = <<"EOS"
\\PassOptionsToPackage{unicode=true}{hyperref} % options for packages loaded elsewhere
\\PassOptionsToPackage{hyphens}{url}
%
\\documentclass[]{ltjarticle}
\\usepackage[top=30truemm,bottom=30truemm,left=25truemm,right=20truemm]{geometry}
\\usepackage{lmodern}
\\usepackage{amssymb,amsmath}
\\usepackage{ifxetex,ifluatex}
\\usepackage{fixltx2e} % provides \\textsubscript
\\ifnum 0\\ifxetex 1\\fi\\ifluatex 1\\fi=0 % if pdftex
  \\usepackage[T1]{fontenc}
  \\usepackage[utf8]{inputenc}
  \\usepackage{textcomp} % provides euro and other symbols
\\else % if luatex or xelatex
  \\usepackage{unicode-math}
  \\defaultfontfeatures{Ligatures=TeX,Scale=MatchLowercase}
\\fi
% use upquote if available, for straight quotes in verbatim environments
\\IfFileExists{upquote.sty}{\\usepackage{upquote}}{}
% use microtype if available
\\IfFileExists{microtype.sty}{%
\\usepackage[]{microtype}
\\UseMicrotypeSet[protrusion]{basicmath} % disable protrusion for tt fonts
}{}
\\IfFileExists{parskip.sty}{%
\\usepackage{parskip}
}{% else
\\setlength{\\parindent}{0pt}
\\setlength{\\parskip}{6pt plus 2pt minus 1pt}
}
\\usepackage[colorlinks,linkcolor=blue,urlcolor=blue]{hyperref}
\\hypersetup{
            pdfborder={0 0 0},
            breaklinks=true}
\\urlstyle{same}  
\\setlength{\\emergencystretch}{3em}  % prevent overfull lines
\\providecommand{\\tightlist}{%
  \\setlength{\\itemsep}{0pt}\\setlength{\\parskip}{0pt}}
\\setcounter{secnumdepth}{5}
% Redefines (sub)paragraphs to behave more like sections
\\ifx\\paragraph\\undefined\\else
\\let\\oldparagraph\\paragraph
\\renewcommand{\\paragraph}[1]{\\oldparagraph{#1}\\mbox{}}
\\fi
\\ifx\\subparagraph\\undefined\\else
\\let\\oldsubparagraph\\subparagraph
\\renewcommand{\\subparagraph}[1]{\\oldsubparagraph{#1}\\mbox{}}
\\fi

% set default figure placement to htbp
\\makeatletter
\\def\\fps@figure{htbp}
\\makeatother


\\usepackage{fancyhdr}
\\pagestyle{fancy}
\\lhead{#{title}}



#{tex_header}
#{content.gsub('\n','\textbackslash')}

EOS

# #{content.gsub('_', '\_').gsub('\\\\','\\').sub('\\begin{document}','')}

#puts tex_text

File.open("./#{@name}_tmp.tex", "w") do |f| 
    f.puts(tex_text)
end

sleep 3

`mv ./#{@name}_tmp.tex ./#{@name}.tex`
`lualatex ./#{@name}.tex`
`lualatex ./#{@name}.tex`
`lualatex ./#{@name}.tex`
`evince ./#{@name}.pdf`
`rm ./#{@name}.out ./#{@name}.toc ./#{@name}.aux  ./#{@name}.log ./tmp.tex`

||<

　今朝，修正したのが「#{content.gsub('\n','\textbackslash')}」という部分の処理になります。ちょっと間違いに気がついたので後で修正しておきますが，バックスラッシュをTex用にエスケープする処理です。pandocで処理されていなかったみたいです。

　pandocから一気にPDFファイルを作成することは出来るのですが，Ubuntu18.04の時は使えていたオプションも使えなくなり，様式の変更が出来なくなっていました。今回はTexファイルを生成しているので，LaTeXとしてなんでもできるかと思います。

