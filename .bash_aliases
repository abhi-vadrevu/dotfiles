# Bash Aliases
# ---------------------------------------------------------------------------------------------
# Misc
check_in_docker() {
  [ "$?" != "0" ] && exit 1
}
alias check_docker='check_in_docker'

# AWS
alias start_devbox='aws_sso --update && source ~/.aws/aws.sh && aws_devbox --start'
alias stop_devbox='aws_sso --update && source ~/.aws/aws.sh && aws_devbox --stop'
alias awsup='aws_sso --update && source ~/.aws/aws.sh'

# Starling
alias starling_setup="bash sim/next_gen/Starling/setup.sh"

# Run scenario with Julia Packages
_run_scenario() {
  . sim/ziplinesim.sh
  julia_packages -tStarlingScenarios -j $1
}
alias run_scenario='_run_scenario'

# Run scenario with scenarios to run
_scenarios_to_run() {
  SCENARIOS_TO_RUN="$1" bash -c "sim/next_gen/Starling/setup.sh -t"
}
alias run_scenarios='_scenarios_to_run'

# Bazel Aliases
bazel_zip_exec_tests() {
  if [ -z "$1" ]; then
    # Run all tests
    bazel test --config host_linux //p2_zip/executive_layer/zip_executive_subsystem:zip_executive_subsystem_tests -k
  else
    # Run specific test
    bazel test --config host_linux //p2_zip/executive_layer/zip_executive_subsystem:zip_executive_subsystem_tests -k --test_arg $1
  fi
}
alias zet='bazel_zip_exec_tests'

bazel_zip_exec_build() {
  bazel build --config host_linux //p2_zip/executive_layer/zip_executive_subsystem:zip_executive_subsystem
}
alias zeb='bazel_zip_exec_build'

bazel_test_package() {
  pkg_path=$1
  pkg_name=${pkg_path##*/}
  echo "Running tests for $pkg_path:$pkg_name"
  if [ -z "$2" ]; then
    # Run all tests
    bazel test --config host_linux //$pkg_path:${pkg_name}_tests -k
  else
    # Run specific test
    bazel test --config host_linux //$pkg_path:${pkg_name}_tests -k --test_arg $2
  fi
}
alias test_package='bazel_test_package'

bazel_build_package() {
  bazel build --config host_linux //$1
}
alias build_package='bazel_build_package'

# Git Aliases
git_log_oneline() {
  git log --oneline -$1 
}
git_rebase() {
  git rebase -i HEAD~$1
}
git_rebase_onto() {
  git rebase -i HEAD~$1 --onto $2
}

alias glog='git_log_oneline'
alias gs='git status'
alias gf='git fetch --all'
alias ga='git add .'
alias gc='git commit'
alias gca='git commit --amend'
alias gr='git_rebase'
alias gro='git_rebase_onto'
alias grc='git rebase --continue'
alias revu='revup upload'

# Revup
alias revup="python -m revup"

# ZML Aliases
alias zpl='zml --zml .starling/logs/latest/zip-0001/compute_a/zml_logger/starling.zml print $1'
alias zpl_es='zml --zml .starling/logs/latest/zip-0001/compute_a/zml_logger/starling.zml print /SIL.zip_executive.executive_status'
alias zll='zml --zml .starling/logs/latest/zip-0001/compute_a/zml_logger/starling.zml list'


# Help Alias
help() {
  echo "Available Aliases:"
  # Print out all the aliases above with a brief description
  echo "----------------- Bazel Aliases -----------------"
  echo "zet - Bazel Test on ZipExec crate. Optional argument to run a specific test, otherwise all tests."
  echo "zeb - Bazel Build the zip exec crate."
  echo "test_package - Bazel Test on specific package. Optional argument to run a specific test, otherwise all tests."
  echo "build_package - Bazel Build a specific package."
  echo "----------------- Git Aliases -----------------"
  echo "glog - Git log oneline."
  echo "gs - Git status."
  echo "gf - Git fetch all."
  echo "ga - Git add all."
  echo "gc - Git commit."
  echo "gca - Git commit amend."
  echo "gr - Git rebase."
  echo "gro - Git rebase onto."
  echo "grc - Git rebase continue."
  echo "revu - Revup upload."
  echo "----------------- ZML Aliases -----------------"
  echo "zpl - Print a zml log."
  echo "zpl_es - Print the executive status zml log."
  echo "zll - List the zml log."
  echo "----------------- Starling Aliases -----------------"
  echo "starling_setup - Setup starling."
  echo "run_scenario - Run a single scenario with julia packages."
  echo "run_scenarios - Run multiple scenarios with SCENARIOS_TO_RUN."
}
alias helpme='help'
