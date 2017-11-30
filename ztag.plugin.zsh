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
    tag_name=$1
    file=$2
    if [ "$#" -eq 2 ]; then
	fpath=$(readlink -f $file)
	tag_dir=$ZTAG_ROOT/tags/$tag_name
	mkdir -p $tag_dir
	if ! ln -s $fpath $tag_dir; then
	   echo "$(basename $fpath) already exists at $tag_dir"
	fi
    fi
}

tagsm() {
    ztag_setup

    tag_name=$1
    files=( ${@:2} )

    for f in $files;
    do
	tag $tag_name $f
    done
}

tagms() {
    ztag_setup

    length=$#
    tags=( ${@:1:$length-1} )
    file=${@:$#}

    for t in $tags;
    do
	tag $t $file
    done
}

tagls() {
    tags=( $@ )
    links=()
    for t in $tags;
    do
	this_tag=($(find $ZTAG_ROOT/tags/$t -type l))
	links=($links $this_tag)
    done

    files=()
    for l in $links;
    do
	this_link=$(readlink -f $l)
	files+=$this_link
    done

    echo "${(@u)files}"
}

ztag_setup
