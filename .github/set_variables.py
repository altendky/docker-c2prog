import json
import os


def set_output(name, value):
    print(f"::set-output name={name}::{json.dumps(value)}")


def main():
    github = json.loads(os.environ["GITHUB_CONTEXT"])
    is_push = github["event_name"] == "push"
    # Consider the workflow triggering branches if changing this
    is_main = github["ref"] == "refs/heads/main"

    user_name, repository_name = github["repository"].partition('/docker-')
    pull_request = github["event"].get("pull_request", {})
    labels = pull_request.get("labels", [])
    pull_request_number = pull_request.get("number", None)

    name = f"{user_name}/{repository_name}"

    for label in labels:
        if label["name"] == "publish":
            publish_label = label
            break
    else:
        publish_label = None

    publish = False
    tag = "latest"

    if is_main:
        if is_push:
            publish = True
    elif publish_label is not None:
        tag = f"pr{pull_request_number}"

    name_and_tag = f"{name}:{tag}"

    set_output("publish", publish)
    set_output("name", name)
    set_output("tag", tag)
    set_output("name_and_tag", name_and_tag)
    set_output("c2prog_url", "http://permanent.fstab.net/c2prog/C2Prog-v1.8.10-r1.tar.gz")

main()
