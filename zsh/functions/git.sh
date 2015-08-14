git_add_remote()
{
    if [ "$#" -ne 2 ]
    then
        echo "Usage: $0 <name> <location>" >&2
        return 1
    fi

    if [[ ! "$2" =~ ^(http|https|git|ssh)://.* ]]
    then
        mkdir -p "$2" && git init --bare "$2"
    elif [[ "$2" =~ ssh://.* ]]
    then
        ssh ${GITSERVER} "mkdir -p /srv/git/${PWD}.git && git init --bare /srv/git/${PWD}.git"
    fi
    git remote add "$1" "$2"
}

git_init()
{
    git init
    PWD=$(pwd | sed 's/\//\
/g' | tail -1)
    git_add_remote origin ${GITURL}/${PWD}.git
    git_add_remote gh https://github.com/sulami/${PWD}.git
}

git_hist()
{
    count=0
    for DIR in $(find -maxdepth 1 -type d); do
        cd $DIR
        let count="count + $(git rev-list --count --since=$1 master)"
        cd ..
    done
    echo "Commits in ${1}: $count"
}

