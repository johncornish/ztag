ztag_setup() {
    if [[ -f .ztagrc ]]; then
	source .ztagrc
    elif [[ -f ~/.ztagrc ]]; then
	source ~/.ztagrc
    fi
    
    if [ -z "${ZTAG_ROOT+1}" ]; then
	ZTAG_ROOT=~
    fi
}

tag() {
    if [ "$#" -eq 2 ]; then
	typeset tag_name=$1 filename=$2 filepath tag_dir
	filepath=$(readlink -f $filename)
	tag_dir=$ZTAG_ROOT/tags/$tag_name
	mkdir -p $tag_dir
	if ! ln -s $filepath $tag_dir 2> /dev/null; then
	   echo "$(basename $fpath) already exists at $tag_dir"
	fi
    fi
}

tagsm() {
    ztag_setup

    typeset tag_name=$1 files=( ${@:2} )

    for f in $files;
    do
	tag $tag_name $f
    done
}

tagms() {
    ztag_setup

    typeset length=$# tags filename=${@:$#}
    tags=( ${@:1:$length-1} )

    for t in $tags;
    do
	tag $t $filename
    done
}

tagls() {
    typeset tags=( $@ ) links=() files=() this_tag this_link

    for t in $tags;
    do
	this_tag=($(find $ZTAG_ROOT/tags/$t -type l))
	links=($links $this_tag)
    done

    for l in $links;
    do
	this_link=$(readlink -f $l)
	files+=$this_link
    done

    echo "${(@u)files}"
}

ztag_setup
