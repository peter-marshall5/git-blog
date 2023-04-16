#!/bin/bash

. ./config

[ "$domain" != "" ] || exit

https_url="https://$domain"
html_path="dist"
html_index="$html_path/index.html"
sitemap="$html_path/sitemap.xml"
res_dir="res"
html_res="$res_dir/html"
gmi_res="$res_dir/gmi"
blog_dir="blog"
blog_path="$html_path/$blog_dir"
title_char_limit=200

if [ -e $html_path ]; then
	rm $html_path -r
fi

mkdir $html_path
mkdir $blog_path

function start_index () {
	cat $html_res/header.html | sed "s/\$NAME/$name/g" | sed "s/\$META/$meta/g" >> $html_index
	cat $gmi_res/header.gmi | sed "s/\$NAME/$name/g" > gmi/index.gmi
	cat <<EOF > $sitemap
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">
EOF
}


function add_index () {
	echo "<div><a href=\"$blog_dir/$1.html\"><h2>$2</h2><p>$3</p></a></div>" >> $html_index
	echo "=> $blog_dir/$1.gmi $2 - $3" >> gmi/index.gmi
	cat <<EOF >> $sitemap
  <url>
    <loc>$https_url/$blog_dir/$1</loc>
    <lastmod>$3</lastmod>
    <priority>1.00</priority>
  </url>
EOF
}

function end_index () {
	cat $html_res/footer.html | sed "s/\$COPYRIGHT/$copyright/g" >> $html_index
	cat $gmi_res/footer.gmi | sed "s/\$COPYRIGHT/$copyright/g" >> gmi/index.gmi
	echo "</urlset>" >> $sitemap
}

function list_start () {
	echo "<ul>"
}

function list_end () {
	echo "</ul>"
}

function list_item () {
	echo "<li>$1</li>"
}

function heading () {
	echo "<h$1>$2</h$1>"
}

function quote () {
	echo "<blockquote>$1</blockquote>"
}

function pre_start () {
	echo "<pre>"
}

function pre_end () {
	echo "</pre>"
}

function link () {
	local url="$1"; shift
	local desc="$@"
	case $url in
		*.jpg | *.png | *.webp )
			echo "<div class="image"><img src=\"$url\" /><p>$desc</p></div>"
			;;
		*)
			echo "<a href=\"$url\">$desc</a>"
			;;
	esac
}

function paragraph () {
	echo "<p>$1</p>"
}

function line_break () {
	echo "<br/>"
}

function generate () {
	cat $html_res/header-post.html | sed "s/\$TITLE/$2/" | sed "s/\$NAME/$name/g"

	local is_list=n
	local is_pre=n
	while IFS= read -r line; do
		if [[ "$is_pre" == "y" ]]; then
			if [[ "$line" == '```'* ]]; then
				is_pre=n
				pre_end
				continue
			fi
			echo "$line"
			continue
		elif [[ "$is_list" == "y" ]]; then
			case "$line" in
				'* '*)
					list_item "${line/\* /}"
					continue
					;;
				*)
					list_end
					is_list=n
					;;
			esac
		fi
		case "$line" in
			'')
				continue
				;;
			'* '*)
				is_list=y
				list_start
				list_item "${line/\* /}"
				;;
			'```'*)
				is_pre=y
				pre_start
				;;
			'# '*)
				heading 1 "${line/\# /}"
				;;
			'## '*)
				heading 2 "${line/\#\# /}"
				;;
			'### '*)
				heading 3 "${line/\#\#\# /}"
				;;
			'> '*)
				quote "${line/\> /}"
				;;
			'=> '*)
				link ${line/\=> /}
				;;
			*)
				paragraph "$line"
				;;
		esac
		first_line=n
	done < $1

	cat $html_res/footer-post.html | sed "s/\$COPYRIGHT/$copyright/g"
}

cp $html_res/main.css $html_res/home.css $html_res/post.css $html_path/
cp gmi/res/ $html_path/ -r
cat $res_dir/robots.txt | sed "s/\$DOMAIN/$domain/" > $html_path/robots.txt
start_index
find gmi/blog/*.gmi | sort -r | while read file; do
	filename=${file/gmi\/blog\//}
	basename="${filename/.gmi/}"
	htmlpath="$blog_path/${filename/.gmi/.html}"
	echo Build $filename

	title=$(cat $file | head -n 1)
	if [[ "$title" =~ ^#.* ]]; then
		title="${title/\# /}"
		date=$(cat $file | head -n 2 | tail -n 1)
	else
		title="$basename"
		date=$(date +"%b %d, %Y")
	fi
	title="${title:0:$title_char_limit}"

	generate "$file" "$title" > "$htmlpath"

	add_index "$basename" "$title" "$date"
done
end_index
