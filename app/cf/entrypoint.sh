export PATH=.:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export LANG="en_US.UTF-8"

case $1 in
    "train")
        pio app new cf
        pio eventserver 
        ;;
    "query")
        pio deploy
        ;;
esac

exit 1;
