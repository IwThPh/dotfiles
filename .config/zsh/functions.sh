if [[ -x "$(command -v zellij)" ]]; then
	attach_session() {
		local session_name

		session_name="$(zellij ls |
			fzf --ansi --border sharp --info=inline --border-label="(Attach Session)" --border-label-pos=3 --height 25% |
			awk '{print $1}')"

		if [ -n "$session_name" ] && [ "$session_name" != " " ]; then
			zellij a "$session_name"
		fi
	}

	delete_session() {
		zellij ls |
			fzf --ansi -m --border sharp --info=inline --border-label="(Delete Sessions| tab to select)" --border-label-pos=3 --height 25% |
			awk '{print $1}' | xargs -I {} zellij delete-session {} --force
	}

	create_sessions() {
		local current_dir
		current_dir="$(pwd)"

		ls -d */ | sed 's|[/]||g' |
			fzf --ansi -m --border sharp --info=inline --border-label="(Create Sessions| tab to select)" --border-label-pos=3 --height 25% |
			awk '{print $1}' | xargs -I {} sh -c "cd {} && zellij attach --create-background {} && cd $current_dir || false"
	}
fi

function pdfdoc() {
	if [ $# -lt 1 ]; then
		echo "Usage: ${funcstack[1]} <filename.md>"
		return
	fi

	filename=$1
	pandoc --to=pdf -o "${filename%.*}.pdf" $filename \
		--from=gfm \
		--pdf-engine=lualatex \
		-V geometry:margin=1in \
		-V 'mainfont:Poppins-Regular.ttf' \
		-V 'mainfontoptions:BoldFont=Poppins-Bold.ttf, ItalicFont=Poppins-Italic.ttf, BoldItalicFont=Poppins-BoldItalic.ttf' \
		-V block-headings \
		--wrap=none
}
