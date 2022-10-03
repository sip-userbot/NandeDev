## Running PandaUserbot

__ziplink () {
    local regex
    regex='(https?)://github.com/.+/.+'
    if [[ $NANDE_USERBOT_REPO == "NANDE_USERBOT" ]]
    then
        echo "https://github.com/MultiUbot/Ubot-Nande/archive/main.zip"
    elif [[ $NANDE_USERBOT_REPO == "UTAMA_USERBOT" ]]
    then
        echo "https://github.com/MultiUbot/Ubot-Nande/archive/main.zip"
    elif [[ $NANDE_USERBOT_REPO =~ $regex ]]
    then
        if [[ $NANDE_USERBOT_REPO_BRANCH ]]
        then
            echo "${NANDE_USERBOT_REPO}/archive/${NANDE_USERBOT_REPO_BRANCH}.zip"
        else
            echo "${NANDE_USERBOT_REPO}/archive/main.zip"
        fi
    else
        echo "https://github.com/MultiUbot/Ubot-Nande/archive/main.zip"
    fi
}

__repolink () {
    local regex
    local rlink
    regex='(https?)://github.com/.+/.+'
    if [[ $UPSTREAM_REPO == "NANDE_USERBOT" ]]
    then
        rlink=`echo "${UPSTREAM_REPO}"`
    else
        rlink=`echo "https://github.com/MultiUbot/Ubot-NANDE"
    fi
    echo "$rlink"
}




_install_python_version() {
    python3${pVer%.*} -c "$1"
}

_install_deploy_git() {
    $(_install_python_version 'from git import Repo
import sys
OFFICIAL_UPSTREAM_REPO = "https://github.com/MultiUbot/Ubot-Nande"
ACTIVE_BRANCH_NAME = "Nande-Userbot"
repo = Repo.init()
origin = repo.create_remote("temponame", OFFICIAL_UPSTREAM_REPO)
origin.fetch()
repo.create_head(ACTIVE_BRANCH_NAME, origin.refs[ACTIVE_BRANCH_NAME])
repo.heads[ACTIVE_BRANCH_NAME].checkout(True) ')
}

_start_install_git() {
    local repolink=$(__repolink)
    $(_run_python_code 'from git import Repo
import sys
OFFICIAL_UPSTREAM_REPO="'$repolink'"
ACTIVE_BRANCH_NAME = "'$UPSTREAM_REPO_BRANCH'" or "main"
repo = Repo.init()
origin = repo.create_remote("temponame", OFFICIAL_UPSTREAM_REPO)
origin.fetch()
repo.create_head(ACTIVE_BRANCH_NAME, origin.refs[ACTIVE_BRANCH_NAME])
repo.heads[ACTIVE_BRANCH_NAME].checkout(True) ')
}


_install_nandeuserbot () {
    local zippath
    zippath="nandeuserbot.zip"
    echo "  Downloading source code ..."
    wget -q $(__ziplink) -O "$zippath"
    echo "  Unpacking Data ..."
    NANDE_USERBOTPATH=$(zipinfo -1 "$zippath" | grep -v "/.");
    unzip -qq "$zippath"
    echo "Done"
    echo "  Cleaning ..."
    rm -rf "$zippath"
    _install_deploy_git
    cd $NANDE_USERBOTPATH
    _start_install_git
    python3 ../setup/updater.py ../requirements.txt requirements.txt
    chmod -R 755 bin
    echo "Starting NANDEUserBot"
    echo "PROSES...... "
    python3 -m userbot
}

_install_nandeuserbot
