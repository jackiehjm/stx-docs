# If set, will be prepended to output paths
common_target="tmp/"
prot="http"

# The repo to download from
remote_repo="opendev.org/starlingx/fault/raw/branch"

# Associate remote files and local paths
# key is the path to target in remote repo, relative to repo root
# value is path and name to be saved, relative to CWD and common_target if set

remote_files=(
    ["fm-doc/fm_doc/events.yaml"]="events.yaml"
    )
